// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/CRCOutbox.sol";

contract CRCOutboxTest is Test {
    event MessageSent(address indexed sender, bytes32 indexed hash, uint256 messageIndex);

    CRCOutbox public outbox;

    function setUp() public {
        outbox = new CRCOutbox();
    }

    function testSendMessage(uint8 version, uint64 nonce, bytes calldata payload) public {
        uint256 chainId = outbox.getChainID();
        bytes32 messageHash = keccak256(abi.encode(version, chainId, address(this), nonce, payload));

        CRCOutbox.CRCMessage memory c = CRCOutbox.CRCMessage({version: version, nonce: nonce, payload: payload});

        vm.expectEmit(true, true, false, true);

        emit MessageSent(address(this), messageHash, 0);
        outbox.sendMessage(c);

        assertEq(outbox.outbox(0), messageHash);

        assertEq(outbox.indexOf(messageHash), 0);

        assertEq(outbox.noncesNullifier(address(this), nonce), true);
    }
}
