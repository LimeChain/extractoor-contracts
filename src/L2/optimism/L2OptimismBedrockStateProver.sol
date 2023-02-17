// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {OptimismBedrockStateProver} from "./../../library/optimism/OptimismBedrockStateProver.sol";
import {Types} from "./../../library/optimism/Types.sol";
import {ILightClient} from "./../ILightClient.sol";

contract L2OptimismBedrockStateProver is OptimismBedrockStateProver {
    ILightClient public immutable lightClient;

    address public immutable berdockOutputOracleAddress;

    uint256 public constant outputOracleOutputProofsSlotPosition = 3;

    constructor(address _lightClient, address _oracleAddress) {
        lightClient = ILightClient(_lightClient);
        berdockOutputOracleAddress = _oracleAddress;
    }

    function proveOutputRoot(
        uint256 blockNumber,
        uint256 outputIndex,
        Types.OutputRootProof calldata outputProof,
        bytes calldata proofsBlob
    ) internal view returns (bool isValid) {
        bytes32 l1StateRoot = lightClient.getL1StateRoot(blockNumber);

        // See https://github.com/ethereum-optimism/optimism/blob/develop/specs/proposals.md#l2-output-commitment-construction
        bytes32 calculatedOutputRoot = keccak256(
            abi.encode(
                versionByte, outputProof.stateRoot, outputProof.withdrawalStorageRoot, outputProof.latestBlockhash
            )
        );

        // The data structure that bedrock saves in the array is 2 slots long thus finding the slot with the output proof requires (2 * index)
        uint256 targetSlot = uint256(keccak256(abi.encode(outputOracleOutputProofsSlotPosition))) + (2 * outputIndex);

        return this.verifyStateProof(
            l1StateRoot, berdockOutputOracleAddress, bytes32(targetSlot), uint256(calculatedOutputRoot), proofsBlob
        );
    }

    function proveInOptimismState(
        uint256 blockNumber,
        uint256 outputIndex,
        Types.OutputRootProof calldata outputProof,
        bytes calldata optimismStateProofsBlob,
        address target,
        bytes32 slotPosition,
        uint256 value,
        bytes calldata proofsBlob
    ) public view returns (bool) {
        require(
            proveOutputRoot(blockNumber, outputIndex, outputProof, optimismStateProofsBlob),
            "Optimism root state was not found in L1"
        );
        return _proveInOptimismState(outputProof.stateRoot, target, slotPosition, value, proofsBlob);
    }
}
