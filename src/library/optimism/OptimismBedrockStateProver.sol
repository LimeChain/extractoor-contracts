// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {CombinedProofVerifier} from "./../../MPT/CombinedProofVerifier.sol";

/// @notice Common functionality for the L1 and L2 Optimism Bedrock State Verifiers
/// @author Perseverance - LimeChain
abstract contract OptimismBedrockStateProver is CombinedProofVerifier {
    /// @dev Current Optimism Bedrock Output Root version_byte.
    /// @dev See https://github.com/ethereum-optimism/optimism/blob/develop/specs/proposals.md#l2-output-commitment-construction
    bytes32 public constant versionByte = bytes32(0);

    /// @dev See CombinedProofVerifier.verifyStateProof
    function _proveInOptimismState(
        bytes32 optimismStateRoot,
        address target,
        bytes32 slotPosition,
        uint256 value,
        bytes calldata proofsBlob
    ) internal view returns (bool) {
        return
            this.verifyStateProof(
                optimismStateRoot,
                target,
                slotPosition,
                value,
                proofsBlob
            );
    }
}
