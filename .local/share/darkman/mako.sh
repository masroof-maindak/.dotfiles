#!/bin/sh

pgrep mako || exit 1

case "$1" in
dark) OTHER=light ;;
light) OTHER=dark ;;
default) exit 1 ;;
esac

makoctl mode -a "$1" -r "$OTHER"
