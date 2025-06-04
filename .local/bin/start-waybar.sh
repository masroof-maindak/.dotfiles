#!/bin/sh

HOSTNAME=`hostname`

WAYBAR_LAPTOP_CONFIG=~/.config/waybar/laptop/config.jsonc
WAYBAR_LAPTOP_STYLES=~/.config/waybar/laptop/styles.css
WAYBAR_ULTRAWIDE_CONFIG=~/.config/waybar/ultrawide/config.jsonc
WAYBAR_ULTRAWIDE_STYLES=~/.config/waybar/ultrawide/styles.css

pkill -x waybar

case $HOSTNAME in
  "sharktooth" | "morningside")
    waybar -c $WAYBAR_LAPTOP_CONFIG -s $WAYBAR_LAPTOP_STYLES &
    ;;
  "rubicon")
    waybar -c $WAYBAR_ULTRAWIDE_CONFIG -s $WAYBAR_ULTRAWIDE_STYLES &
    ;;
  *)
    notify-send "[Waybar] Unknown hostname: `hostname`"
    exit 1
    ;;
esac

