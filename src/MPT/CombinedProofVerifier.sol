// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {StateProofVerifier as Verifier} from "./StateProofVerifier.sol";
import {RLPReader} from "Solidity-RLP/RLPReader.sol";

/// @notice Combined Account and Storage Proofs Verifier
/// @author Perseverance - LimeChain
/// @author Inspired from https://github.com/lidofinance/curve-merkle-oracle
contract CombinedProofVerifier {
    using RLPReader for bytes;
    using RLPReader for RLPReader.RLPItem;

    /// @dev verifies proof for a specific target based on the state root
    /// @param stateRoot is the state root we are proving against
    /// @param target is the account we are proving for
    /// @param slotPosition is the slot position that we will be getting the value for
    /// @param value is the value we are trying to prove is in the slot
    /// @param proofsBlob is ann rlp encoded array of the account proof and the storage proof. Each of these is the rlp encoded nibbles that is the corresponding proof. This is normally returned by eth_getProof.
    function verifyStateProof(
        bytes32 stateRoot,
        address target,
        bytes32 slotPosition,
        uint256 value,
        bytes calldata proofsBlob
    ) public pure returns (bool) {
        RLPReader.RLPItem[] memory proofs = proofsBlob.toRlpItem().toList();
        require(proofs.length == 2, "total proofs");

        Verifier.Account memory account = Verifier.extractAccountFromProof(
            keccak256(abi.encodePacked(target)),
            stateRoot,
            proofs[0].toList()
        );

        require(account.exists, "Account does not exist or proof is incorrect");

        Verifier.SlotValue memory storageValue = Verifier
            .extractSlotValueFromProof(
                keccak256(abi.encodePacked(slotPosition)),
                account.storageRoot,
                proofs[1].toList()
            );

        require(storageValue.exists, "Storage Value not found");

        require(
            storageValue.value == value,
            "Incorrect value found on this position"
        );

        return true;
    }
}
