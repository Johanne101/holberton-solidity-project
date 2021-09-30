# Assignment

Build a simple NFT exchange.  A user should be able to transfer their NFT to the exchange, set the price of the NFT in ETH, sell to another user, buyer withdraws or resells.  The exchange should also allow a user to update their NFT's price, relist/delist the NFT from sale, and withdraw.

General Requirements:

- must use [ERC721](https://eips.ethereum.org/EIPS/eip-721) and/or [ERC1155](https://eips.ethereum.org/EIPS/eip-1155) standards
- exchange must support pricing NFTs in ETH
- must use hardhat

Minimum required unit test coverage:

- seller deposits NFT into exchange
- seller sets NFT price
- seller updates NFT price
- sell NFT to another user
- buyer relists NFT for sale
- buyer delists NFT
- buyer withdraws NFT from exchange

Bonus points:

- allow contract to have an [owner](https://docs.openzeppelin.com/contracts/4.x/access-control)
- allow marketplace contract to collect a fee on every NFT sale, allow exchange owner to withdraw fee
- allow smart contracts to interact with exchange, see [IERC721Receiver.sol](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol) [IERC1155Receiver.sol](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/IERC1155Receiver.sol)
- allow 3rd party tokens (allow someone to bid in another token than ETH such as USDC, DAI, LINK, etc)
- allow user to deposit/withdraw multiple NFTs
- allow your contract to be [upgraded](https://docs.openzeppelin.com/contracts/4.x/upgradeable)

Security considerations:

- only the NFT owner should be able to deposit, list, update price, delist, and withdraw an NFT
- only the marketplace owner should be able to perform any owner related functions

### Questions

If you have questions, post them in the Q&A section of the discussion tab.
