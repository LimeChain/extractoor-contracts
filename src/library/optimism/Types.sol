// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/**
 * @title Types
 * @notice Contains various types used throughout the Optimism contract system.
 */
library Types {
    /**
     * @notice OutputProposal represents a commitment to the L2 state. The timestamp is the L1
     *         timestamp that the output root is posted. This timestamp is used to verify that the
     *         finalization period has passed since the output root was submitted.
     *
     * @custom:field outputRoot    Hash of the L2 output.
     * @custom:field timestamp     Timestamp of the L1 block that the output root was submitted in.
     * @custom:field l2BlockNumber L2 block number that the output corresponds to.
     */
    struct OutputProposal {
        bytes32 outputRoot;
        uint128 timestamp;
        uint128 l2BlockNumber;
    }

    /**
     * @notice Struct representing the elements that are hashed together to generate an output root
     *         which itself represents a snapshot of the L2 state.
     *
     * @custom:field version                  Version of the output root.
     * @custom:field stateRoot                Root of the state trie at the block of this output.
     * @custom:field withdrawalStorageRoot    Root of the withdrawal storage trie.
     * @custom:field latestBlockhash          Hash of the block this output was generated from.
     */
    struct OutputRootProof {
        bytes32 stateRoot;
        bytes32 withdrawalStorageRoot;
        bytes32 latestBlockhash;
    }
}
