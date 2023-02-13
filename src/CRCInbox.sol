// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract CRCInbox {
    struct CRCMessage {
        bytes data;
    }

    bytes32[] public inbox;
}
