// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {StateProofVerifier as Verifier} from "./MPT/StateProofVerifier.sol";
import {RLPReader} from "Solidity-RLP/RLPReader.sol";

contract CRCProver {
    using RLPReader for bytes;
    using RLPReader for RLPReader.RLPItem;

    /// @dev verifies proof for a specific target based on the state root
    /// @param stateRoot is the state root we are proving against
    /// @param target is the account we are proving for
    /// @param accountProof is an array of rlp encoded nibbles that is the account proof. This is normally returned by eth_getProof.
    function verifyProof(bytes32 stateRoot, address target, bytes[] calldata accountProof) public returns (bool) {
        uint256 proofLen = accountProof.length;
        RLPReader.RLPItem[] memory rlpAccountProofList = new RLPReader.RLPItem[](proofLen);
        for (uint256 i = 0; i < proofLen; i++) {
            rlpAccountProofList[i] = accountProof[i].toRlpItem();
        }
        Verifier.Account memory account =
            Verifier.extractAccountFromProof(keccak256(abi.encodePacked(target)), stateRoot, rlpAccountProofList);

        return true;
    }
}
