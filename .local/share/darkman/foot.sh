#!/bin/sh

config="$HOME/.config/foot/foot.ini"

case "$1" in
dark)
    NUM=1
    THEME=dark
    ;;
light)
    NUM=2
    THEME=light
    ;;
default) exit 1 ;;
esac

sed -i "s|^initial-color-theme=.*|initial-color-theme=$THEME|" "$config"
killall -SIGUSR$NUM foot
