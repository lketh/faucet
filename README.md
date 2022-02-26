# Rusty Faucet

This is a simple Faucet that created with `yew` and `bulma` based from the [router example](https://github.com/yewstack/yew/tree/master/examples/router), while the frontend only requests funds and displays previous activity, it is interesting to note that it was written in rust and it is running using webassembly with [trunks](https://trunkrs.dev/).

The rest of the application (`contracts`, `tests`) were done using solidity and foundry, see more below

## Motivation

I've been eager to learn rust for a while but it's hard without a project or idea to put some code into, so here it goes...

## Frontend installation

To get this up and running you will need to do:

```bash
rustup target add wasm32-unknown-unknown
cargo install --locked trunk
```

## Running the frontend

While not strictly necessary, this example should be built in release mode:

```bash
trunk serve --release
```

# Faucet contract

This is regular solidity, but tests were written using [foundry](https://github.com/gakonst/foundry) also built with rust, based in the [foundry-rust-template](https://github.com/gakonst/foundry-rust-template) that you can find there.

## Installing foundry

## Directory Structure

The project is structured as a mixed Rust workspace with a Foundry project under
`contracts/` and typesafe auto-generated bindings to the contracts under
`bindings/`.

```
├── Cargo.toml
├── app // <-- Your Rust application logic
├── contracts // <- The smart contracts + tests using Foundry
├── bindings // <-- Generated bindings to the smart contracts' abis (like Typechain)
```

## Testing

Given the repository contains both Solidity and Rust code, there's 2 different
workflows.

### Solidity

If you are in the root directory of the project, run:

```bash
forge test --root ./contracts
```

If you are in in `contracts/`:

```bash
forge test
```

### Rust

```
cargo test
```

## Generating Rust bindings to the contracts

Rust bindings to the contracts can be generated via `forge bind`, which requires
first building your contracts:

```
forge build --root ./contracts
forge bind --bindings-path ./bindings --root ./contracts --crate-name bindings
```

Any follow-on calls to `forge bind` will check that the generated bindings match
the ones under the build files. If you want to re-generate your bindings, pass
the `--overwrite` flag to your `forge bind` command.

## Installing Foundry

First run the command below to get `foundryup`, the Foundry toolchain installer:

```sh
curl -L https://foundry.paradigm.xyz | bash
```

Then, in a new terminal session or after reloading your `PATH`, run it to get
the latest `forge` and `cast` binaries:

```sh
foundryup
```

For more, see the official
[docs](https://github.com/gakonst/foundry#installation).
You can find more details in the inner readme file.

```bash
forge build --root ./contracts
forge bind --bindings-path ./bindings --root ./contracts --crate-name bindings
```
