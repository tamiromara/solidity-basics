Blockchain Oracles: any device that interacts with off-chain world to provide data or computation to smart contracts.

We can't just make regular api calls for such data and this will prevent the nodes from reaching consensus.

Chainlink Data Feeds:

- Decentralized network of chainlink nodes.
- Exchanges provide the data to data aggregators.
- Data aggregators sends the data to chainlink nodes.
- chainlink nodes does it think then delivers it into a Reference Contract.

Chainlink services:

- VRF
- Keepers
- Function

Reading data from Price Feed Address:

- Import `AggregatorV3Interface` to the contract.
- Create the interface object `priceFeed` by pointing to the price feed (proxy address?)
