#!/bin/sh

active="$HOME/.config/niri/active.kdl"

case "$1" in
dark) printf 'include "swamp-dark.kdl"\n' >"$active" ;;
light) printf 'include "swamp-light.kdl"\n' >"$active" ;;
default) exit 1 ;;
esac
