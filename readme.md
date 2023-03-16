# lesson1
**lesson1** is a blockchain built using Cosmos SDK and Tendermint and created with [Ignite CLI](https://ignite.com/cli).

## Get started

```
ignite chain serve
```

`serve` command installs dependencies, builds, initializes, and starts your blockchain in development.

### Configure

Your blockchain in development can be configured with `config.yml`. To learn more, see the [Ignite CLI docs](https://docs.ignite.com).

### Web Frontend

Ignite CLI has scaffolded a Vue.js-based web app in the `vue` directory. Run the following commands to install dependencies and start the app:

```
cd vue
npm install
npm run serve
```

The frontend app is built using the `@starport/vue` and `@starport/vuex` packages. For details, see the [monorepo for Ignite front-end development](https://github.com/ignite/web).

## Release
To release a new version of your blockchain, create and push a new tag with `v` prefix. A new draft release with the configured targets will be created.

```
git tag v0.1
git push origin v0.1
```

After a draft release is created, make your final changes from the release page and publish it.

### Install
To install the latest version of your blockchain node's binary, execute the following command on your machine:

```
curl https://get.ignite.com/username/lesson_1@latest! | sudo bash
```
`username/lesson_1` should match the `username` and `repo_name` of the Github repository to which the source code was pushed. Learn more about [the install process](https://github.com/allinbits/starport-installer).

## Learn more

- [Ignite CLI](https://ignite.com/cli)
- [Tutorials](https://docs.ignite.com/guide)
- [Ignite CLI docs](https://docs.ignite.com)
- [Cosmos SDK docs](https://docs.cosmos.network)
- [Developer Chat](https://discord.gg/ignite)

# SDK Vietnam community class

## I. Chapter 1: Chain Interaction

Purpose: Chain interaction serves as cornerstone in helping a person get familiar with Cosmos SDK

1. Group 1: Starting a chain

- [Lesson 1: Scaffolding and starting a chain](docs/chapter_1/lesson_1.md)
- [Lesson 2: Configuration of node ports](docs/chapter_1/lesson_2.md)

2. Group 2: Interacting with a chain through cli

- [Lesson 3: Keyring](docs/chapter_1/lesson_3.md)
- [Lesson 4: Making a transaction through CLI](docs/chapter_1/lesson_4.md)
- [Lesson 5: Making a query through CLI](docs/chapter_1/lesson_5.md)
- [Lesson 6: Monitoring your node (version, status)](docs/chapter_1/lesson_6.md)

3. Group 3: Interacting with a chain through API

- [Lesson 7: Making a transaction through API](docs/chapter_1/lesson_7.md)
- [Lesson 8: Making a query through API](docs/chapter_1/lesson_8.md)

4. Group 4: Chain configuration

- [Lesson 9: Enable API server in app.toml](docs/chapter_1/lesson_9.md)
- [Lesson 10: Introduction to client.toml](docs/chapter_1/lesson_10.md)
- Lesson 11: Introduction to genesis.json (genesis_time, chain_id, consensus_params)
- Lesson 12: Dive deeper into app_state module configuration (accounts, bank, staking)
- Lesson 13: Dive deeper into app_state module configuration (mint, distribution, gov)

5. Group 5: Setting up a validator

- Lesson 14: Setting up validator for new chain (add-genesis-account, tendermint, gentx, validate-genesis)
- Lesson 15: Chapter 1 practice

## II. Chapter 2: Building a custom module

1. Group 1: Protobuf
- Lesson 1: Write a protobuf struct in Cosmos
- Lesson 2: Generate protobuf struct
1. Group 2: Write a chain module
- Lesson 3: Integrate module into app.go
- Lesson 4: Add new chain module data structure
- Lesson 5: Add new chain module logic
- Lesson 6: Add chain module CLI interaction
- Lesson 7: Add handling for chain module logic genesis state
- Lesson 8: Expose new chain module logic in module.go
- Lesson 9: Integrate new chain module logic to app.go
1. Group 3: Testing
- Lesson 10: Add unit testing
- Lesson 11: Add system testing
1. Group 4: Scripts
- Lesson 12: start node and local-net script
- Lesson 13: development script in Makefile
1. Group 5: Capstone project
- Lesson 14: Practice building a simple text module part 1
- Lesson 15: Practice building a simple text module part 2