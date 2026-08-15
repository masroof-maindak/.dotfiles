#!/bin/sh

case "$1" in
dark) pkill -USR1 foot ;;
light) pkill -USR2 foot ;;
default) exit 1 ;;
esac
