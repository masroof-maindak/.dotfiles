#!/usr/bin/env bash

replace_hex_codes() {
    local input="$1"
    local output="$input"

    declare -A color_replacements=(
        ["1d2021"]="211d13" # DarkHard
        ["282828"]="242015" # Dark1 / BG
        ["3c3836"]="3A3124" # Dark2
        ["504945"]="4D3F32" # Dark3
        ["665c54"]="5F4E41" # Dark4
        ["7c6f64"]="725C4F" # Dark5
        ["928374"]="856a5d" # Dark6 / DarkGrey

        ["a89984"]="9F8875" # Light5 / LightGrey
        ["bdae93"]="B8A58C" # Light4
        ["d5c4a1"]="D2C3A4" # Light3
        ["ebdbb2"]="ebe0bb" # Light2 / FG
        ["fbf1c7"]="F1E9D0" # Light1

        ["d65d0e"]="db930d" # DarkOrange
        ["fe8019"]="db930d" # Orange

        ["d79921"]="db930d" # DarkYellow
        ["fabd2f"]="db930d" # Yellow

        ["458588"]="91506c" # DarkBlue
        ["83a598"]="91506c" # Blue

        ["98971a"]="6f682c" # DarkGreen
        ["b8bb26"]="6f682c" # Green

        ["b16286"]="d45d67" # DarkMagenta
        ["d3869b"]="d45d67" # Magenta

        ["cc241d"]="a93b5c" # DarkRed
        ["fb4934"]="a93b5c" # Red

        ["689d6a"]="A8663C" # DarkCyan
        ["8ec07c"]="A8663C" # Cyan
    )

    for hex in "${!color_replacements[@]}"; do
        output="${output//${hex}/${color_replacements[$hex]}}"
    done

    echo "$output"
}

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 filename"
    exit 1
fi

filename="$1"

if [ ! -f "$filename" ]; then
    echo "Error: Unable to open file: $filename"
    exit 1
fi

# Backup the original file
cp "$filename" "$filename.bak"

# Create a temporary file for processing
tempfile=$(mktemp)

while IFS= read -r line; do
    replaced_line=$(replace_hex_codes "$line")
    echo "$replaced_line" >>"$tempfile"
done <"$filename"

# Replace the original file with the modified file
mv "$tempfile" "$filename"
