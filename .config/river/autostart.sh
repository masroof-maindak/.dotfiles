#!/bin/sh

# FIXME
riverctl spawn "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
riverctl spawn "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=river"

riverctl spawn "kanshi -c ~/.config/kanshi/config-macbook13inch"
riverctl spawn "eww -c ~/.config/eww-river open topbar"
riverctl spawn "swww-daemon"
riverctl spawn "dunst"
riverctl spawn "foot --server"
riverctl spawn "wlsunset -l 31.4 -L 74.3"
riverctl spawn "wl-paste --watch cliphist store"
