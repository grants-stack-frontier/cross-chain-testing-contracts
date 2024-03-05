# Cross Chain Donation Adapters

The contracts in this repository are Proof of Concepts of cross-chain bridging solutions. We've implemented a simple mock af the AlloV2 `allocate` method and created an adapter contract to support the Connext donation flow.


> [!WARNING]  
> This is not suitable for production and comes with issues. We've deployed to production nets to get accurate cost estimates without trying to find a way around testnet API.


## Architecture

The process involves:
- The user: the person who wants to donate tokens.
- The bridge: the contract that will receive the tokens and send them to the recipient on another chain.
- The round: a round instance on the AlloV2 protocol.
- The recipient: the person who will receive the tokens on another chain as part of the grants round they're participating in.
- The source chain: the chain where the tokens are currently located.
- The target chain: the chain where the recipient is participating in a grants round.
- The adapter contract: a Connext specific contract that executes validations and supports custom logic.

When executing a cross-chain donation vote, the following steps are taken:

- The user specifies the amount of tokens to donate, the address of the token to donate, and the address of the recipient.
- The user creates a donation vote transaction using the API of the bridging solution.
- The user signs the transaction with their wallet and sends it to the bridge.
- The bridge receives the transaction and verifies the signature.
- The bridge receives the tokens and sends them to the target contract on the target chain.

On the target chain, the flow is different between the different bridging solutions. 

In the case of Connext, the adapter contract is the `CrossChainDonationAdapter` contract which receives the tokens and the calldata.

- The bridge sends the tokens to the adapter contract. 
- The adapter contract receives the tokens and the calldata, validates the data and executes the custom logic on the Allo contract.
- Tokens are received by the adapter contract and relayed to the recipient via the Allo contract.

In the case of LiFi and Decent, there is no adapter contract and the bridge could execute calls directly onto the Allo contract.

- The bridge sends the tokens to the Allo contract.
- The Allo contract receives the tokens and the calldata, validates the data and executes the custom logic.

> This has the caveat that the tokens will be owned by Allo and should be routed out of the Allo contract to the recipient.

## Contracts

- CrossChainDonationAdapter: the adapter contract that receives the tokens and the calldata, validates the data and executes the custom logic on the Allo contract.
- MockAllo: a mock of the AlloV2 contract that implements the `allocate` method.


## Deployments

| Network  | Contract                  | Address                                                                                                                          |
| -------- | ------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| Optimism | MockAllo                  | [0xfB1eD3Fe2978c8aCf1cBA19145D7349A4730EfAd](https://optimistic.etherscan.io/address/0xfB1eD3Fe2978c8aCf1cBA19145D7349A4730EfAd) |
| Optimism | CrossChainDonationAdapter | [0x8795b9E65C9dbe0934CE537b39359c21dc81Cf54](https://optimistic.etherscan.io/address/0x8795b9e65c9dbe0934ce537b39359c21dc81cf54) |
| Polygon  | MockAllo                  | [0x0a0DF97bDdb36eeF95fef089A4aEb7acEaBF2101](https://polygonscan.com/address/0x0a0DF97bDdb36eeF95fef089A4aEb7acEaBF2101)         |
| Polygon  | CrossChainDonationAdapter | [0xa16DFb32Eb140a6f3F2AC68f41dAd8c7e83C4941](https://polygonscan.com/address/0xa16DFb32Eb140a6f3F2AC68f41dAd8c7e83C4941)         |
| Arbitrum | MockAllo                  | [0x0a0DF97bDdb36eeF95fef089A4aEb7acEaBF2101](https://arbiscan.io/address/0x0a0df97bddb36eef95fef089a4aeb7aceabf2101)             |
| Arbitrum | CrossChainDonationAdapter | [0xa16DFb32Eb140a6f3F2AC68f41dAd8c7e83C4941](https://arbiscan.io/address/0xa16dfb32eb140a6f3f2ac68f41dad8c7e83c4941)             |

## What's Inside

- [Forge](https://github.com/foundry-rs/foundry/blob/master/forge): compile, test, fuzz, format, and deploy smart
  contracts
- [Forge Std](https://github.com/foundry-rs/forge-std): collection of helpful contracts and cheatcodes for testing
- [PRBTest](https://github.com/PaulRBerg/prb-test): modern collection of testing assertions and logging utilities
- [Prettier](https://github.com/prettier/prettier): code formatter for non-Solidity files
- [Solhint](https://github.com/protofire/solhint): linter for Solidity code

## Getting Started

Click the [`Use this template`](https://github.com/PaulRBerg/foundry-template/generate) button at the top of the page to
create a new repository with this repo as the initial state.

Or, if you prefer to install the template manually:

```sh
$ mkdir my-project
$ cd my-project
$ forge init --template PaulRBerg/foundry-template
$ bun install # install Solhint, Prettier, and other Node.js deps
```

If this is your first time with Foundry, check out the
[installation](https://github.com/foundry-rs/foundry#installation) instructions.

## Features

This template builds upon the frameworks and libraries mentioned above, so please consult their respective documentation
for details about their specific features.

For example, if you're interested in exploring Foundry in more detail, you should look at the
[Foundry Book](https://book.getfoundry.sh/). In particular, you may be interested in reading the
[Writing Tests](https://book.getfoundry.sh/forge/writing-tests.html) tutorial.

### Sensible Defaults

This template comes with a set of sensible default configurations for you to use. These defaults can be found in the
following files:

```text
├── .editorconfig
├── .gitignore
├── .prettierignore
├── .prettierrc.yml
├── .solhint.json
├── foundry.toml
└── remappings.txt
```

### VSCode Integration

This template is IDE agnostic, but for the best user experience, you may want to use it in VSCode alongside Nomic
Foundation's [Solidity extension](https://marketplace.visualstudio.com/items?itemName=NomicFoundation.hardhat-solidity).

For guidance on how to integrate a Foundry project in VSCode, please refer to this
[guide](https://book.getfoundry.sh/config/vscode).

### GitHub Actions

This template comes with GitHub Actions pre-configured. Your contracts will be linted and tested on every push and pull
request made to the `main` branch.

You can edit the CI script in [.github/workflows/ci.yml](./.github/workflows/ci.yml).

## Installing Dependencies

Foundry typically uses git submodules to manage dependencies, but this template uses Node.js packages because
[submodules don't scale](https://twitter.com/PaulRBerg/status/1736695487057531328).

This is how to install dependencies:

1. Install the dependency using your preferred package manager, e.g. `bun install dependency-name`
   - Use this syntax to install from GitHub: `bun install github:username/repo-name`
2. Add a remapping for the dependency in [remappings.txt](./remappings.txt), e.g.
   `dependency-name=node_modules/dependency-name`

Note that OpenZeppelin Contracts is pre-installed, so you can follow that as an example.

## Writing Tests

To write a new test contract, you start by importing [PRBTest](https://github.com/PaulRBerg/prb-test) and inherit from
it in your test contract. PRBTest comes with a pre-instantiated [cheatcodes](https://book.getfoundry.sh/cheatcodes/)
environment accessible via the `vm` property. If you would like to view the logs in the terminal output you can add the
`-vvv` flag and use [console.log](https://book.getfoundry.sh/faq?highlight=console.log#how-do-i-use-consolelog).

This template comes with an example test contract [Foo.t.sol](./test/Foo.t.sol)

## Usage

This is a list of the most frequently needed commands.

### Build

Build the contracts:

```sh
$ forge build
```

### Clean

Delete the build artifacts and cache directories:

```sh
$ forge clean
```

### Compile

Compile the contracts:

```sh
$ forge build
```

### Coverage

Get a test coverage report:

```sh
$ forge coverage
```

### Deploy

Deploy to Anvil:

```sh
$ forge script script/Deploy.s.sol --broadcast --fork-url http://localhost:8545
```

For this script to work, you need to have a `MNEMONIC` environment variable set to a valid
[BIP39 mnemonic](https://iancoleman.io/bip39/).

For instructions on how to deploy to a testnet or mainnet, check out the
[Solidity Scripting](https://book.getfoundry.sh/tutorials/solidity-scripting.html) tutorial.

### Format

Format the contracts:

```sh
$ forge fmt
```

### Gas Usage

Get a gas report:

```sh
$ forge test --gas-report
```

### Lint

Lint the contracts:

```sh
$ bun run lint
```

### Test

Run the tests:

```sh
$ forge test
```

Generate test coverage and output result to the terminal:

```sh
$ bun run test:coverage
```

Generate test coverage with lcov report (you'll have to open the `./coverage/index.html` file in your browser, to do so
simply copy paste the path):

```sh
$ bun run test:coverage:report
```

## Related Efforts

- [abigger87/femplate](https://github.com/abigger87/femplate)
- [cleanunicorn/ethereum-smartcontract-template](https://github.com/cleanunicorn/ethereum-smartcontract-template)
- [foundry-rs/forge-template](https://github.com/foundry-rs/forge-template)
- [FrankieIsLost/forge-template](https://github.com/FrankieIsLost/forge-template)

## License

This project is licensed under MIT.
