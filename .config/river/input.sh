#!/bin/sh

# Trackpad
riverctl input pointer-1452-602-bcm5974 events enabled
riverctl input pointer-1452-602-bcm5974 events disabled-on-external-mouse
riverctl input pointer-1452-602-bcm5974 tap enabled
riverctl input pointer-1452-602-bcm5974 click-method clickfinger
riverctl input pointer-1452-602-bcm5974 tap-button-map left-right-middle
riverctl input pointer-1452-602-bcm5974 disable-while-typing enabled
riverctl input pointer-1452-602-bcm5974 pointer-accel 0.3

# Keyboard repeat rate
riverctl set-repeat 50 300
