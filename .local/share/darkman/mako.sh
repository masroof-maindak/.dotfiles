#!/bin/sh

pgrep mako || exit 1

config="$HOME/.config/mako/config"

case "$1" in
dark)   sed -i 's|^include=.*|include=~/.config/mako/swamp-dark|' "$config" ;;
light)  sed -i 's|^include=.*|include=~/.config/mako/swamp-light|' "$config" ;;
default) exit 1 ;;
esac

makoctl reload
