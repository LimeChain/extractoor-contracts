[![MIT License][license-shield]][license-url]

# Extractoor contracts

Library of contracts used for proving the Merkle Patricia Tree (MPT) inclusion of a certain storage inside a rollup. For easy generation of proofs and their encoding you can use the contracts alongside with the [extractoor](https://github.com/LimeChain/extractoor-sdk) typescript sdk.It is part of the ongoing effort of [LimeLabs](https://limelabs.tech) and [LimeChain](https://limechain.tech) to give back and contribute to the blockchain community in the form of open source tooling and public goods infrastructure.

## Installation

To install with [**Foundry**](https://github.com/gakonst/foundry):

```sh
forge install LimeChain/extractoor-contracts
```

## Contracts
```ml
MPT
├─ MerklePatriciaProofVerifier — "Verifier for Ethereum MPT Proofs"
├─ CombinedProofVerifier — "Combined Account and Storage Proofs Verifier"
├─ StateProofVerifier — "A helper library for verification of Merkle Patricia account and state proofs"
library
├─ optimism
│  ├─ OptimismBedrockStateProver — "Common functionality for the L1 and L2 Optimism Bedrock State Verifiers"
│  ├─ Types — "Contains various types used throughout the Optimism verification process"
L1
├─ optimism
│  ├─ IOptimismBedrockOutputOracle — "Interface for the Optimism Bedrock Output Proover"
│  ├─ L1OptimismBedrockStateProver — "Contract for verification of MPT inclusion inside Optimism Bedrock from within the anchored L1"
L2
├─ ILightClient — "Interface for input of L1 state root to the L2 state prover"
├─ SimpleLightClient — "Simple contract that can be used as LightClient providing state roots for blocks by their number"
├─ optimism
│  ├─ L2OptimismBedrockStateProver — "Role based Authority that supports up to 256 roles"
```

## Why L1 and L2 contracts
For each rollup there are two types of contracts - L1 and L2. 

The L1 contracts can be used in the Ethereum L1 where the rollups anchor. They call the contracts and get the state roots (or some derivation of them) and verify MPT inclusion against it. 

The L2 contracts can be used in external networks and count on the L1 anchor state root to be read via an interface `ILightClient`. Depending on your use case you would need to write your own implementation of `ILightClient` or use our `SimpleLightClient`. Two MPT proofs are used inside the L2 contract - one proving the existence of the rollup root (or its derivatives) and one proving the actual storage against the proven rollup state root.

## Supported rollups

- [x] Optimism Bedrock
    - [x] Optimism Goerli
    - [x] Base Goerli

## Contributing

Feel free to make a pull request. **All unit tests must pass!**

## Safety

This is **experimental software** and is provided on an "as is" and "as available" basis.

We **do not give any warranties** and **will not be liable for any loss** incurred through any use of this codebase.

Please always include your own thorough tests when using Extractoor to make sure it works correctly with your code. 

## Acknowledgements

These contracts were inspired by or directly modified from many sources, primarily:

- [Lido Finance](https://github.com/lidofinance/curve-merkle-oracle)
- [Optimism Bedrock](https://github.com/ethereum-optimism/optimism/tree/develop/packages/contracts-bedrock/contracts)

[license-shield]: https://img.shields.io/badge/License-MIT-green.svg
[license-url]: https://github.com/LimeChain/extractoor-contracts/blob/main/LICENSE.txt