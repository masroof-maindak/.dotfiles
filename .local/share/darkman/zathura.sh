#!/bin/sh

# Point zathura at the palette for the current darkman mode. The colours live
# in ~/.config/zathura/swamp-{light,dark}-rc; this only flips the include=
# line. zathura reads its config at every launch, so the next invocation picks
# up the theme.

config="$HOME/.config/zathura/zathurarc"

case "$1" in
dark)   sed -i 's|^include .*|include swamp-dark-rc|' "$config" ;;
light)  sed -i 's|^include .*|include swamp-light-rc|' "$config" ;;
default) exit 1 ;;
esac