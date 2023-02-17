# CRC Extractoor contracts
Set of contracts used for proving the inclusion of a certain storage inside rollups. Currently supported rollups:
- Optimism Bedrock

For each rollup there are two types of contracts - L1 and L2. L1 contracts can be used in Ethereum L1 where the rollups anchor. They call the contracts containing the state roots (or its derivatives) and verify MPT inclusion against it. The L2 contracts can be used in external networks and count on the L1 anchor state root to be read. Two MPT proofs are used inside the L2 contract - one proving the existence of the rollup root (or its derivatives) and one proving the actual storage against the proven rollup state root.