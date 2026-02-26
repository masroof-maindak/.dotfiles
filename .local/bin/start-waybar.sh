#!/usr/bin/env sh

HOSTNAME=$(hostname)

CFG_DIR="$HOME/.config/waybar"
LAPTOP_CFG="$CFG_DIR/laptop/config.jsonc"
LAPTOP_STYLES="$CFG_DIR/laptop/styles.css"
ULTRAWIDE_CFG="$CFG_DIR/ultrawide/config.jsonc"
ULTRAWIDE_STYLES="$CFG_DIR/ultrawide/styles.css"

which waybar >/dev/null 2>&1 || {
    notify-send "[Waybar] waybar not found"
    exit 1
}

pkill -x waybar

case "$HOSTNAME" in
"sharktuth" | "morningside")
    waybar -c "$LAPTOP_CFG" -s "$LAPTOP_STYLES" &
    ;;
"rubicon")
    waybar -c "$ULTRAWIDE_CFG" -s "$ULTRAWIDE_STYLES" &
    ;;
*)
    notify-send "[Waybar] Unknown hostname: $HOSTNAME"
    exit 1
    ;;
esac
