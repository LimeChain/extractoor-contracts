// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface ILightClient {
    function getL1StateRoot(uint256 blockNumber) external view returns (bytes32);
}
