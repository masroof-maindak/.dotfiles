#!/bin/sh

active="$HOME/.config/delta/active.gitconfig"

case "$1" in
dark) printf '[delta]\n\tfeatures = swamp-dark\n' >"$active" ;;
light) printf '[delta]\n\tfeatures = swamp-light\n' >"$active" ;;
default) exit 1 ;;
esac
