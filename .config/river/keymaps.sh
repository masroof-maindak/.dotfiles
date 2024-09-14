#!/bin/sh

### RUNNING STUFF
riverctl map normal Super Return spawn 'footclient'
riverctl map normal Super+Shift Return spawn 'footclient -a floatyFoot'

riverctl map normal Super D spawn '~/.config/rofi/scripts/launcher.sh'

# Screenshots
riverctl map normal Super P spawn 'grim -g "$(slurp)" - | wl-copy && wl-paste > ~/Screenshots/$(date +%F_%T).png'
riverctl map normal Super+Shift P spawn 'grim - | wl-copy && wl-paste > ~/Screenshots/$(date +%F_%T)_full.png'

# Common Software
riverctl map normal Super W spawn 'cosmic-files'
riverctl map normal Super B spawn 'firefox'
riverctl map normal Super V spawn 'code'

### PASSTHROUGH MODE
# Declare a passthrough mode. This mode has only a single mapping to return to
# normal mode. This makes it useful for testing a nested wayland compositor
riverctl declare-mode passthrough
riverctl map normal Super F11 enter-mode passthrough # Enter
riverctl map passthrough Super F11 enter-mode normal # Exit

### MEDIA KEYS
for mode in normal locked; do
	riverctl map $mode None XF86AudioMute spawn 'amixer sset Master toggle'
	riverctl map -repeat $mode None XF86AudioRaiseVolume spawn 'amixer sset Master 2%+'
	riverctl map -repeat $mode None XF86AudioLowerVolume spawn 'amixer sset Master 2%-'
	riverctl map -repeat $mode None XF86KbdBrightnessUp spawn 'brightnessctl --device='smc::kbd_backlight' set 5%+'
	riverctl map -repeat $mode None XF86KbdBrightnessDown spawn 'brightnessctl --device='smc::kbd_backlight' set 5%-'
	riverctl map -repeat $mode None XF86MonBrightnessUp spawn 'brightnessctl set 5%+'
	riverctl map -repeat $mode None XF86MonBrightnessDown spawn 'brightnessctl set 5%-'

	riverctl map $mode None XF86AudioMedia spawn 'playerctl play-pause'
	riverctl map $mode None XF86AudioPlay spawn 'playerctl play-pause'
	riverctl map $mode None XF86AudioPrev spawn 'playerctl previous'
	riverctl map $mode None XF86AudioNext spawn 'playerctl next'
done

### LAYOUT MANAGER AGNOSTIC STACK MANAGEMENT
# Focus next/prev window
riverctl map normal Super H focus-view left
riverctl map normal Super J focus-view down
riverctl map normal Super K focus-view up
riverctl map normal Super L focus-view right
riverctl map normal Super Semicolon focus-view next
riverctl map normal Super+Shift Semicolon focus-view previous

# Swap next/prev window
riverctl map normal Super+Shift H swap left
riverctl map normal Super+Shift J swap down
riverctl map normal Super+Shift K swap up
riverctl map normal Super+Shift L swap right

# Focus next/prev display
riverctl map normal Super Period focus-output next
riverctl map normal Super Comma focus-output previous

# Send window to next/prev display
riverctl map normal Super+Shift Period send-to-output next
riverctl map normal Super+Shift Comma send-to-output previous

# Swap with highest master
riverctl map normal Super+Control Return zoom

### FLOATING
## Keyboard
# Move
riverctl map -repeat normal Super Y move left 10
riverctl map -repeat normal Super U move down 10
riverctl map -repeat normal Super I move up 10
riverctl map -repeat normal Super O move right 10

# Snap to edge
riverctl map normal Super C snap center
riverctl map normal Super+Alt+Control H snap left
riverctl map normal Super+Alt+Control J snap down
riverctl map normal Super+Alt+Control K snap up
riverctl map normal Super+Alt+Control L snap right

# Resize
riverctl map -repeat normal Super+Alt+Shift H resize horizontal -10
riverctl map -repeat normal Super+Alt+Shift J resize vertical 10
riverctl map -repeat normal Super+Alt+Shift K resize vertical -10
riverctl map -repeat normal Super+Alt+Shift L resize horizontal 10

## Mouse
# Move
riverctl map normal Super X spawn '$HOME/.config/river/pointer_action.sh'
riverctl map-pointer normal Super BTN_LEFT resize-view

# Resize
riverctl map-pointer normal Super BTN_RIGHT resize-view

# Toggle
riverctl map-pointer normal Super BTN_MIDDLE toggle-float

### GENERAL PURPOSE
riverctl map normal Super Space toggle-float
riverctl map normal Super F toggle-fullscreen

riverctl map normal Super Q close
riverctl map normal Super+Shift Q exit

riverctl map normal Super Tab spawn 'flow cycle-tags next 9 -o'
riverctl map normal Super+Shift Tab spawn 'flow cycle-tags previous 9 -o'

### TAG MANAGEMENT
all_tags=$(((1 << 32) - 1))
sticky_tag=$((1 << 31))
all_but_sticky_tag=$(($all_tags ^ $sticky_tag))

riverctl map normal Super S toggle-view-tags $sticky_tag
riverctl spawn-tagmask ${all_but_sticky_tag}

for i in $(seq 1 9); do
	tags=$((1 << ($i - 1)))

	# move to tag i
	riverctl map normal Super $i set-focused-tags $(($sticky_tag + $tags))

	# send to tag i
	riverctl map normal Super+Shift $i set-view-tags $tags

	# Toggle focus of tag i
	riverctl map normal Super+Control $i toggle-focused-tags $tags

	# Toggle tag i of active window
	riverctl map normal Super+Shift+Control $i toggle-view-tags $tags
done

# Focus all tags
riverctl map normal Super 0 set-focused-tags $all_tags

# Tag active window with all tags
riverctl map normal Super+Shift 0 set-view-tags $all_tags

### LAYOUT MANAGER
riverctl map -repeat normal Super bracketleft send-layout-cmd rivertile "main-ratio -0.02"
riverctl map -repeat normal Super bracketright send-layout-cmd rivertile "main-ratio +0.02"

riverctl map normal Super equal send-layout-cmd rivertile "main-count +1"
riverctl map normal Super minus send-layout-cmd rivertile "main-count -1"

riverctl map normal Super Up send-layout-cmd rivertile "main-location top"
riverctl map normal Super Right send-layout-cmd rivertile "main-location right"
riverctl map normal Super Down send-layout-cmd rivertile "main-location bottom"
riverctl map normal Super Left send-layout-cmd rivertile "main-location left"
