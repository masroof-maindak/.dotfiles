#!/bin/sh

BORDER_WIDTH=10

while bspc subscribe -c 1 node_focus; do
	bspc config border_width 1
	bspc config -n focused border_width $BORDER_WIDTH
done
