mode=$(eww get mode)

mode=$(if [ "$mode" = "move" ]; then
    echo "resize"
else
    echo "move"
fi)

riverctl map-pointer normal Super BTN_LEFT ${mode}-view
eww update mode="$mode"

