#!/bin/sh

# Point spotify-player at the named theme for the current darkman mode. The
# themes live in ~/.config/spotify-player/theme.toml; this only flips the
# theme= line in app.toml. spotify-player reads its config at launch, so the
# next invocation picks up the theme.

config="$HOME/.config/spotify-player/app.toml"

case "$1" in
dark)   sed -i 's|^theme = .*|theme = "swamp dark"|' "$config" ;;
light)  sed -i 's|^theme = .*|theme = "swamp light"|' "$config" ;;
default) exit 1 ;;
esac