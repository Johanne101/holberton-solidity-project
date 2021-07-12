//SPDX-License-Identifier: Unlicense
pragma solidity ^0.6.12;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/ILiquidityProtection.sol";
import "./interfaces/ILiquidityProtectionStore.sol";

import "hardhat/console.sol";

contract DappStakingPool is OwnableUpgradeable {
    using SafeMath for uint;

    struct UserStakeInfo {
        uint amount;     // How many tokens the user has provided.
        uint pending;
        uint rewardDebt; // Reward debt. See explanation below.
        uint positionId;
        //uint[] positionIds;
    }

    ILiquidityProtection public liquidityProtection;
    ILiquidityProtectionStore public liquidityProtectionStore;

    IERC20 public dappToken;
    IERC20 public bntToken;

    address dappBntPoolAnchor;

    uint public totalLpStaked;
    uint public accDappPerShare; // Accumulated DAPP per share, times 1e12
    uint public lastRewardBlock;  // Last block number that DAPP distribution occurs.
    uint public dappPerBlock;
    uint public startBlock;

    uint public dappILSupply; // amount of DAPP held by contract to cover IL
    uint public dappRewardsSupply; // amount of DAPP held by contract to cover rewards

    mapping (address => UserStakeInfo) public userStakeInfo;

    function initialize(
        address _liquidityProtection,
        address _dappBntPoolAnchor,
        address _dappToken,
        address _bntToken
    ) external initializer {
        __Ownable_init(); 
        liquidityProtection = ILiquidityProtection(_liquidityProtection);
        dappBntPoolAnchor = _dappBntPoolAnchor;
        dappToken = IERC20(_dappToken);
        bntToken = IERC20(_bntToken);

        dappToken.approve(address(liquidityProtection), uint(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF));
    }

    modifier updateRewards() {
        if (block.number <= lastRewardBlock) {
            return;
        }
        if (totalLpStaked == 0) {
            lastRewardBlock = block.number;
            return;
        }
        uint multiplier = (block.number).sub(lastRewardBlock);
        uint dappReward = multiplier.mul(dappPerBlock);
        accDappPerShare = accDappPerShare.add(dappReward.mul(1e12).div(totalLpStaked));
        lastRewardBlock = block.number;
        _;
    }

    function stakeDappBnt(uint amount) public updateRewards {
    }

    function unstakeDappBnt(uint amount) public updateRewards {
    }

    function stakeDapp(uint amount) public updateRewards {
        dappToken.transferFrom(msg.sender, address(this), amount);
        UserStakeInfo storage userInfo = userStakeInfo[msg.sender];

        if (userInfo.amount > 0) {
            uint256 pending = userInfo.amount.mul(accDappPerShare).div(1e12).sub(userInfo.rewardDebt);
            userInfo.pending = userInfo.pending.add(pending);
        }
        (uint targetAmount, uint baseAmount, uint networkAmount) = liquidityProtection.removeLiquidityReturn(userInfo.positionId, 1000000, block.timestamp);
        (,,, uint256 prevLpAmount,,,,) = liquidityProtectionStore.protectedLiquidity(userInfo.positionId);
        // to make sure the contract only manages one position per user, we withdraw
        // all then redeposit with added amount
        liquidityProtection.removeLiquidity(userInfo.positionId, 1000000);
        uint diff = targetAmount.sub(baseAmount);
        if (diff > 0) {
            if (dappILSupply >= diff) {
                // cover difference from IL, burn BNT
                dappILSupply = dappILSupply.sub(diff);
                amount = amount.add(targetAmount);
                bntToken.transfer(address(0), networkAmount);
            } else {
                // if can't afford, only add base amount, compensate with bnt
                amount = amount.add(baseAmount);
                bntToken.transfer(msg.sender, networkAmount);
            }
        } else {
            amount = amount.add(targetAmount);
        }
        uint positionId = liquidityProtection.addLiquidity(dappBntPoolAnchor, address(dappToken), amount);
        (,,, uint256 postLpAmount,,,,) = liquidityProtectionStore.protectedLiquidity(positionId);
        totalLpStaked = totalLpStaked.add(postLpAmount.sub(prevLpAmount));
        userInfo.positionId = positionId;
        userInfo.amount = postLpAmount;
        userInfo.rewardDebt = userInfo.amount.mul(accDappPerShare).div(1e12);
    }

    // portion of total staked, PPM
    function unstakeDapp(uint32 portion) public updateRewards {
        UserStakeInfo storage userInfo = userStakeInfo[msg.sender];

        (uint targetAmount, uint baseAmount, uint networkAmount) = liquidityProtection.removeLiquidityReturn(userInfo.positionId, portion, block.timestamp);
        liquidityProtection.removeLiquidity(userInfo.positionId, portion);
        uint diff = targetAmount.sub(baseAmount);
        (,,, uint256 newLpAmount,,,,) = liquidityProtectionStore.protectedLiquidity(userInfo.positionId);

        uint256 pendingReward = userInfo.pending.add(userInfo.amount.mul(accDappPerShare).div(1e12).sub(userInfo.rewardDebt));
        if(pendingReward > 0) {
            if (dappRewardsSupply > pendingReward) {
                dappToken.transfer(msg.sender, pendingReward);
                dappRewardsSupply = dappRewardsSupply.sub(pendingReward);
                userInfo.pending = 0;
                userInfo.rewardDebt = (newLpAmount).mul(accDappPerShare).div(1e12);
            } else {
                dappToken.transfer(msg.sender, dappRewardsSupply);
                dappRewardsSupply = 0;
                userInfo.pending = userInfo.pending = pendingReward.sub(dappRewardsSupply);
                userInfo.rewardDebt = (newLpAmount).mul(accDappPerShare).div(1e12);
            }
        }

        totalLpStaked = totalLpStaked.sub(userInfo.amount.sub(newLpAmount));
        userInfo.amount = newLpAmount;

        if (diff > 0) {
            if (dappILSupply >= diff) {
                // cover difference from IL, burn BNT
                dappILSupply = dappILSupply.sub(diff);
                dappToken.transfer(msg.sender, diff);
                bntToken.transfer(address(0), networkAmount);
            } else {
                // if can't afford, only add base amount, compensate with bnt
                bntToken.transfer(msg.sender, networkAmount);
            }
        }

    }

    function harvest() public updateRewards {
        UserStakeInfo storage userInfo = userStakeInfo[msg.sender];
        uint256 pendingReward = userInfo.pending.add(userInfo.amount.mul(accDappPerShare).div(1e12).sub(userInfo.rewardDebt));
        if(pendingReward > 0 && dappRewardsSupply > pendingReward) {
            dappToken.transfer(msg.sender, pendingReward);
            dappRewardsSupply = dappRewardsSupply.sub(pendingReward);
            userInfo.pending = 0;
            userInfo.rewardDebt = userInfo.amount.mul(accDappPerShare).div(1e12);
        }
    }
}