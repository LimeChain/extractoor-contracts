// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {CRCProver} from "./../CRCProver.sol";

contract OptimismBedrockStateProver is CRCProver {
    bytes32 public constant versionByte = bytes32(0);

    /// @dev See CRCProver.verifyStateProof
    function _proveInOptimismState(
        bytes32 optimismStateRoot,
        address target,
        bytes32 slotPosition,
        uint256 value,
        bytes calldata proofsBlob
    ) internal view returns (bool) {
        return this.verifyStateProof(optimismStateRoot, target, slotPosition, value, proofsBlob);
    }
}
