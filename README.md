# Rusty Faucet

This is a simple Faucet that created with `yew` and `bulma` based from the [router example](https://github.com/yewstack/yew/tree/master/examples/router), while the frontend only requests funds and displays previous activity, it is interesting to note that it was written in rust and it is running using webassembly with [trunks](https://trunkrs.dev/).

## Motivation

I've been eager to learn rust for a while but it's hard without a project or idea to put some code into, so here it goes...

## Folders

There are two folders, the frontend described at the top is in the `faucet` folder and the contracts and tests are in `faucet-contract`.

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

## Folders

You will notice that we have an `application` folder, `tests`, and `contracts`, since we have a separate frontend we will use this application as you would use the scripts folder with hardhat.

## Installing

You can find more details in the inner readme file.

```bash
forge build --root ./contracts
forge bind --bindings-path ./bindings --root ./contracts --crate-name bindings
```
