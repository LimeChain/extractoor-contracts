// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract CRCOutbox {
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

    /// @dev sends CRC message. Stores it as keccak hash
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
