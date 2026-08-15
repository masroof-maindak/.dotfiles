#!/bin/sh

case "$1" in
dark) THEME=prefer-dark ;;
light) THEME=prefer-light ;;
default) exit 1 ;;
esac

gsettings set org.gnome.desktop.interface color-scheme $THEME
