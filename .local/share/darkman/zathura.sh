#!/bin/sh

active="$HOME/.config/zathura/active-rc"

case "$1" in
dark) printf 'include swamp-dark-rc\n' >"$active" ;;
light) printf 'include swamp-light-rc\n' >"$active" ;;
default) exit 1 ;;
esac
