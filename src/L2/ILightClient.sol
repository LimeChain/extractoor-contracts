// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @notice Interface for input of L1 state root to the L2 state prover
/// @author Perseverance - LimeChain
interface ILightClient {
    /// @notice Should return the state root of L1 by its block number
    /// @param blockNumber The block number of the L1 block that the state root is requested
    /// @return The state root for the given block number
    function executionStateRoot(uint64 blockNumber)
        external
        view
        returns (bytes32);
}
