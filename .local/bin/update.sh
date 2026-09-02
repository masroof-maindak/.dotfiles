#/usr/bin/env bash

paru

cargo install-update --all

rustup update

nvim --headless "+Lazy! sync" +qa
