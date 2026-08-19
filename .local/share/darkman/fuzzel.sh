#!/bin/sh

active="$HOME/.config/fuzzel/active.ini"

case "$1" in
dark) printf 'include=~/.config/fuzzel/swamp-dark.ini\n' >"$active" ;;
light) printf 'include=~/.config/fuzzel/swamp-light.ini\n' >"$active" ;;
default) exit 1 ;;
esac
