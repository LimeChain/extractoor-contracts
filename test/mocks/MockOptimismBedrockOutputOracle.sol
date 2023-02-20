// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Types} from "./../../src/library/optimism/Types.sol";
import {IOptimismBedrockOutputOracle} from "./../../src/L1/optimism/IOptimismBedrockOutputOracle.sol";

contract MockOptimismBedrockOutputOracle is IOptimismBedrockOutputOracle {
    Types.OutputProposal public s;

    function setState(Types.OutputProposal calldata _s) external {
        s = _s;
    }

    function getL2Output(uint256 _l2OutputIndex)
        external
        view
        returns (Types.OutputProposal memory)
    {
        return s;
    }
}
