// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {SimpleLightClient} from "./../../src/L2/SimpleLightClient.sol";

contract MockLightClient is SimpleLightClient {
    constructor(address owner) SimpleLightClient(owner) {}
}
