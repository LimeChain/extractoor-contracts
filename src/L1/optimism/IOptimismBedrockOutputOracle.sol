// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Types} from "./../../library/optimism/Types.sol";

interface IOptimismBedrockOutputOracle {
    function getL2Output(uint256 outputIndex) external view returns (Types.OutputProposal memory);
}
