#!/bin/sh

pgrep mako || exit 1

active="$HOME/.config/mako/active"

case "$1" in
dark) printf 'include=~/.config/mako/swamp-dark\n' >"$active" ;;
light) printf 'include=~/.config/mako/swamp-light\n' >"$active" ;;
default) exit 1 ;;
esac

makoctl reload
