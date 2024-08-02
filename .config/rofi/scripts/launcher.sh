#!/usr/bin/env bash

FILE=launcher.rasi

if [ "$1" = "-w" ]; then
  FILE=launcher-wayland.rasi
fi

rofi -show drun -theme ~/.config/rofi/${FILE}
