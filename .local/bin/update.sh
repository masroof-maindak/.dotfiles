#/usr/bin/env bash

paru

rustup update

cargo install-update --all

nvim --headless "+Lazy! sync" +qa
