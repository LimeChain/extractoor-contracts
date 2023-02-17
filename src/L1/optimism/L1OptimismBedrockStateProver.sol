// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {OptimismBedrockStateProver} from "./../../library/optimism/OptimismBedrockStateProver.sol";
import {IOptimismBedrockOutputOracle} from "./IOptimismBedrockOutputOracle.sol";
import {Types} from "./../../library/optimism/Types.sol";

contract L1OptimismBedrockStateProver is OptimismBedrockStateProver {
    IOptimismBedrockOutputOracle public immutable outputOracle;

    constructor(address bedrockOutputOracle) {
        outputOracle = IOptimismBedrockOutputOracle(bedrockOutputOracle);
    }

    function proveOutputRoot(uint256 outputIndex, Types.OutputRootProof calldata outputProof)
        internal
        view
        returns (bool isValid)
    {
        Types.OutputProposal memory oracleOutputRoot = outputOracle.getL2Output(outputIndex);
        require(oracleOutputRoot.outputRoot > 0x0, "Invalid index supplied");

        // See https://github.com/ethereum-optimism/optimism/blob/develop/specs/proposals.md#l2-output-commitment-construction
        bytes32 calculatedOutputRoot = keccak256(
            abi.encode(
                versionByte, outputProof.stateRoot, outputProof.withdrawalStorageRoot, outputProof.latestBlockhash
            )
        );

        return calculatedOutputRoot == oracleOutputRoot.outputRoot;
    }

    function proveInOptimismState(
        uint256 outputIndex,
        Types.OutputRootProof calldata outputProof,
        address target,
        bytes32 slotPosition,
        uint256 value,
        bytes calldata proofsBlob
    ) public view returns (bool) {
        require(proveOutputRoot(outputIndex, outputProof), "Optimism root state was not found in L1");
        return _proveInOptimismState(outputProof.stateRoot, target, slotPosition, value, proofsBlob);
    }
}
