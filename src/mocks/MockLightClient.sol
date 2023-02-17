// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ILightClient} from "./../L2/ILightClient.sol";

contract MockLightClient is ILightClient {
    bytes32 public stateRoot;

    function setState(bytes32 _state) external {
        stateRoot = _state;
    }

    function getL1StateRoot(uint256 blockNumber) external view returns (bytes32) {
        return stateRoot;
    }
}
