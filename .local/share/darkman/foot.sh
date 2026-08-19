#!/bin/sh

active="$HOME/.config/foot/active.ini"

case "$1" in
dark)
    printf 'initial-color-theme=dark\n' >"$active"
    NUM=1
    ;;
light)
    printf 'initial-color-theme=light\n' >"$active"
    NUM=2
    ;;
default) exit 1 ;;
esac

killall -SIGUSR$NUM foot
