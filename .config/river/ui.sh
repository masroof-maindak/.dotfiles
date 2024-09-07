#!/bin/sh

# Set backuround and border color
riverctl background-color 0x242015
riverctl border-color-focused 0xDB930D
riverctl border-color-unfocused 0x3A3124

# Make all views with an app-id that starts with "float" and title "foo" start floating.
riverctl rule-add -app-id 'float*' -title 'foo' float
riverctl rule-add -app-id 'Spotify' float
riverctl rule-add -app-id 'floatyFoot' float

# Make all views with app-id "bar" and any title use client-side decorations
riverctl rule-add csd -app-id "bar"

# Add borders
riverctl rule-add ssd
