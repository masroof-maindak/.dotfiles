#!/bin/bash

on=$(bspc config border_width)
off=0

bspc query -N -n .floating.window | xargs -I {node} bspc config -n {node} border_width "$on"
bspc query -N -n .!floating.window | xargs -I {node} bspc config -n {node} border_width "$off"

while read -r _ _ _ node state status; do
	[[ "$state" == "floating" ]] && bspc config -n "$node" border_width "${!status}"
done < <(bspc subscribe node_state)
