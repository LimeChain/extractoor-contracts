// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ILightClient} from "./ILightClient.sol";

/// @notice Simple contract that can be used as "LightClient" providing state roots for blocks by their number
/// @dev DO NOT USE IN PRODUCTION
/// @author Perseverance - LimeChain
abstract contract SimpleLightClient is ILightClient {
    event StateRootSet(uint256 indexed blockNumber, bytes32 indexed state);

    mapping(uint256 => bytes32) public stateRootFor;

    /// @notice Method for setting the state root for a given block number in L1
    /// @param blockNumber The L1 block number
    /// @param _state The state root
    function setStateRoot(uint256 blockNumber, bytes32 _state) external {
        stateRootFor[blockNumber] = _state;
        emit StateRootSet(blockNumber, _state);
    }

    /// See ILightClient
    function getL1StateRoot(uint256 blockNumber)
        external
        view
        returns (bytes32)
    {
        return stateRootFor[blockNumber];
    }
}
