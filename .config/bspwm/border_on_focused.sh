#!/bin/sh

bw=$(bspc config border_width)

while bspc subscribe -c 1 node_focus; do
	bspc config border_width 0
	bspc config -n focused border_width $bw
done
