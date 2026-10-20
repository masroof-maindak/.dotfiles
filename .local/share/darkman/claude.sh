#!/bin/sh

# Claude Code doesn't hot-reload the `theme` setting, but it does reload theme
# files, so swap the contents of the selected `custom:swamp` theme instead
themes="${CLAUDE_CONFIG_DIR:-$HOME/.config/claude}/themes"
active="$themes/swamp.json"

case "$1" in
dark) variant=swamp-dark ;;
light) variant=swamp-light ;;
default) exit 1 ;;
esac

sed "s/\"name\": \"$variant\"/\"name\": \"swamp\"/" "$themes/$variant.json" >"$active"
