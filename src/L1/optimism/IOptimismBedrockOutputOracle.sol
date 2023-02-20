// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Types} from "./../../library/optimism/Types.sol";

/// @notice Interface for the Optimism Bedrock Output Proover
/// @author Perseverance - LimeChain
/// @author Relates to https://github.com/ethereum-optimism/optimism/blob/develop/packages/contracts-bedrock/contracts/L1/L2OutputOracle.sol
interface IOptimismBedrockOutputOracle {
    /// @notice Should return output by index.
    /// @param outputIndex Index of the output to return.
    /// @return The output at the given index.
    function getL2Output(uint256 outputIndex)
        external
        view
        returns (Types.OutputProposal memory);
}
