#!/bin/sh

config="$HOME/.config/spotify-player/app.toml"

case "$1" in
dark) sed -i 's|^theme = .*|theme = "swamp dark"|' "$config" ;;
light) sed -i 's|^theme = .*|theme = "swamp light"|' "$config" ;;
default) exit 1 ;;
esac
