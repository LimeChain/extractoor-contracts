// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {StateProofVerifier as Verifier} from "./MPT/StateProofVerifier.sol";
import {RLPReader} from "Solidity-RLP/RLPReader.sol";

contract CRCOutbox {
    using RLPReader for bytes;
    using RLPReader for RLPReader.RLPItem;

    /// @dev outbox for messages
    bytes32[] public outbox;

    /// @dev getting index by the message hash
    mapping(bytes32 => uint256) public indexOf;

    /// @dev used to nullify nonces
    mapping(address => mapping(uint64 => bool)) public noncesNullifier;

    struct CRCMessage {
        uint8 version;
        uint64 nonce;
        bytes payload;
    }

    event MessageSent(address indexed sender, bytes32 indexed hash, uint256 messageIndex);

    function sendMessage(CRCMessage calldata message) public returns (bytes32 messageHash) {
        require(!noncesNullifier[msg.sender][message.nonce], "Nonce already used");

        uint256 messageIndex = outbox.length;

        uint256 chainId = getChainID();

        noncesNullifier[msg.sender][message.nonce] = true;

        messageHash = keccak256(abi.encode(message.version, chainId, msg.sender, message.nonce, message.payload));

        outbox.push(messageHash);
        indexOf[messageHash] = messageIndex;

        emit MessageSent(msg.sender, messageHash, messageIndex);

        return messageHash;
    }

    function getChainID() public view returns (uint256) {
        uint256 id;
        assembly {
            id := chainid()
        }
        return id;
    }
}
