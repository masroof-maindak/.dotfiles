#!/bin/sh

FLOATING_BORDER_WIDTH=10
BORDER_WIDTH=1

bspc subscribe node_state | while read msg monitor desktop wid state value ; do
if [ $state = "floating" ] ; then
    if [ $value = "on" ] ; then
        bspc config -n $wid border_width $FLOATING_BORDER_WIDTH
    else # Used to reset the border width when the window is no longer floating
        bspc config -n $wid border_width $BORDER_WIDTH
    fi
fi
done
