#!/bin/sh

config="$HOME/.config/fuzzel/fuzzel.ini"

case "$1" in
dark)   sed -i 's|^include=.*|include=~/.config/fuzzel/swamp-dark.ini|' "$config" ;;
light)  sed -i 's|^include=.*|include=~/.config/fuzzel/swamp-light.ini|' "$config" ;;
default) exit 1 ;;
esac
