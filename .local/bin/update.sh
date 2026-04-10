#/usr/bin/env bash

paru

cargo install-update --all

nvim --headless "+Lazy! sync" +qa
