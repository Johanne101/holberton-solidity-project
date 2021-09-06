// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

// interface files are for interacting
// with other contracts, specify params for
// functions and expected return types
interface IExample {
    function exampleFunc(
        address _sourceToken, 
        address _targetToken
    ) external view returns (address[] memory);
}