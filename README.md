# ERC721_Implementation - Smart contracts [![Open in Gitpod][gitpod-badge]][gitpod] [![Github Actions][gha-badge]][gha] [![Foundry][foundry-badge]][foundry] [![License: MIT][license-badge]][license]

[gitpod]: https://gitpod.io/#https://github.com/babamovandrej/ERC721A_Implementation
[gitpod-badge]: https://img.shields.io/badge/Gitpod-Open%20in%20Gitpod-FFB45B?logo=gitpod
[gha]: https://github.com/babamovandrej/ERC721A_Implementation/actions
[gha-badge]: https://github.com/babamovandrej/ERC721A_Implementation/actions/workflows/ci.yml/badge.svg
[foundry]: https://getfoundry.sh/
[foundry-badge]: https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg
[license]: https://opensource.org/licenses/MIT
[license-badge]: https://img.shields.io/badge/License-MIT-blue.svg

## About 

The ERC721A_Implementation repository uses the PaulRBerg/foundry-template and implements the ERC721A standard for batch minting.

## Getting Started

In order to install the template manually:

```sh
forge init my-project --template https://github.com/PaulRBerg/foundry-template
cd my-project
yarn install # install Solhint, Prettier, and other tools
```

If this is your first time with Foundry, check out the
[installation](https://github.com/foundry-rs/foundry#installation) instructions.

### Sensible Defaults

This template comes with sensible default configurations in the following files:

```text
├── .commitlintrc.yml
├── .editorconfig
├── .gitignore
├── .lintstagedrc.yml
├── .prettierignore
├── .prettierrc.yml
├── .solhintignore
├── .solhint.json
├── .yarnrc.yml
├── foundry.toml
└── remappings.txt
```
## Usage

Here's a list of the most frequently needed commands.

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
$ forge script script/DeployFoo.s.sol --broadcast --fork-url http://localhost:8545
```

## Technical details

The minter is the main smart contract for the collection. It is non-upgradeable contract, which implements the ERC721A token standard, for batch minting. 

The `mint` function is the main function which allows minting tokens. The users can mint multiple assets at once, at a lower transaction fee.

I used [Foundry](https://book.getfoundry.sh/) for development, and this repository is created from the [PRB's foundry template](https://github.com/PaulRBerg/foundry-template).

## License

[MIT](./LICENSE.md) © Andrej Babamov