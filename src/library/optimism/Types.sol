// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @notice Contains various types used throughout the Optimism verification process.
/// @author Perseverance - LimeChain
/// @author Inspired by the Types of Optimism Bedrock https://github.com/ethereum-optimism/optimism/tree/develop/packages/contracts-bedrock/contracts
library Types {
    /// @notice OutputProposal represents a commitment to the L2 state. The timestamp is the L1
    ///        timestamp that the output root is posted. This timestamp is used to verify that the
    ///        finalization period has passed since the output root was submitted.
    ///
    /// outputRoot    Hash of the L2 output.
    /// timestamp     Timestamp of the L1 block that the output root was submitted in.
    /// l2BlockNumber L2 block number that the output corresponds to.

    struct OutputProposal {
        bytes32 outputRoot;
        uint128 timestamp;
        uint128 l2BlockNumber;
    }

    ///@notice Struct representing the elements that are hashed together to generate an output root
    ///        which itself represents a snapshot of the L2 state.
    /// version                  Version of the output root.
    /// stateRoot                Root of the state trie at the block of this output.
    /// withdrawalStorageRoot    Root of the withdrawal storage trie.
    /// latestBlockhash          Hash of the block this output was generated from.
    struct OutputRootProof {
        bytes32 stateRoot;
        bytes32 withdrawalStorageRoot;
        bytes32 latestBlockhash;
    }

    ///@notice Struct representing MPT Inclusion proof
    /// target                  The account that this proof should be proven for
    /// slotPosition            The storage slot that should be proven for
    /// proofsBlob              RLP encoded list of the account and storage proofs
    struct MPTInclusionProof {
        address target;
        bytes32 slotPosition;
        bytes proofsBlob;
    }

    ///@notice Struct representing MPT Inclusion proof
    /// outputRootProof                  The output proof structure
    /// optimismStateProofsBlob          The MPT RLP encoded list of the account and storage proofs to prove the output root
    struct OutputRootMPTProof {
        Types.OutputRootProof outputRootProof;
        bytes optimismStateProofsBlob;
    }
}
