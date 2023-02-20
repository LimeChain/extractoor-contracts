// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {OptimismBedrockStateProver} from "./../../library/optimism/OptimismBedrockStateProver.sol";
import {IOptimismBedrockOutputOracle} from "./IOptimismBedrockOutputOracle.sol";
import {Types} from "./../../library/optimism/Types.sol";

/// @notice Contract for verification of MPT inclusion inside Optimism Bedrock from within the anchored L1
/// @author Perseverance - LimeChain
/// @dev Depends on an external contract - OutputOracle maintained by Optimism Bedrock
/// @dev The verification happens in two stages.
/// @dev Stage 1 is verification that the output root exists inside the Optimism Bedrock Output Oracle
/// @dev Stage 2 uses the state root inside the output root and performs MPT inclusion proving for data inside
contract L1OptimismBedrockStateProver is OptimismBedrockStateProver {
    IOptimismBedrockOutputOracle public immutable outputOracle;

    constructor(address bedrockOutputOracle) {
        outputOracle = IOptimismBedrockOutputOracle(bedrockOutputOracle);
    }

    /// @notice Internal method to verify that the output root corresponding to the output proof exists inside the Optimism Bedrock Output Oracle for the given index
    /// @param outputIndex The index to find the output proof at inside the Bedrock OutputOracle
    /// @param outputProof The proof needed to verify the Optimism Bedrock output root and therefore the state root to prove against
    /// @return isValid if the output root is indeed there
    function proveOutputRoot(
        uint256 outputIndex,
        Types.OutputRootProof calldata outputProof
    ) internal view returns (bool isValid) {
        Types.OutputProposal memory oracleOutputRoot = outputOracle.getL2Output(
            outputIndex
        );
        require(oracleOutputRoot.outputRoot > 0x0, "Invalid index supplied");

        /// @dev See https://github.com/ethereum-optimism/optimism/blob/develop/specs/proposals.md#l2-output-commitment-construction
        bytes32 calculatedOutputRoot = keccak256(
            abi.encode(
                versionByte,
                outputProof.stateRoot,
                outputProof.withdrawalStorageRoot,
                outputProof.latestBlockhash
            )
        );

        return calculatedOutputRoot == oracleOutputRoot.outputRoot;
    }

    /// @notice Verifies that a certain expected value is located at the specified storage slot at the specified target account inside Optimism Bedrock
    /// @dev Performs both stages of verification.
    /// @param outputIndex The index to find the output proof of Optimism Bedrock to prove against
    /// @param outputProof The proof needed to verify the Optimism Bedrock output root and therefore the state root to prove against
    /// @param inclusionProof The MPT Inclusion proof to verify the expected value is found in the specified storage slot for the specified account
    /// @param expectedValue The expected value to be in the storage slot
    /// @return isValid if the expected value is indeed there
    function proveInOptimismState(
        uint256 outputIndex,
        Types.OutputRootProof calldata outputProof,
        Types.MPTInclusionProof calldata inclusionProof,
        uint256 expectedValue
    ) public view returns (bool isValid) {
        require(
            proveOutputRoot(outputIndex, outputProof),
            "Optimism root state was not found in L1"
        );
        return
            _proveInOptimismState(
                outputProof.stateRoot,
                inclusionProof.target,
                inclusionProof.slotPosition,
                expectedValue,
                inclusionProof.proofsBlob
            );
    }
}
