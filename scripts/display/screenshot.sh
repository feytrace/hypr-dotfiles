#!/bin/bash

DIR="$HOME/Pictures/screenshots"
mkdir -p "$DIR"

BASE="screenshot_$(date +%Y%m%d)"
EXT=".png"
COUNTER=1

# Find the highest existing counter for today
max_counter=$(ls "$DIR" | grep -E "^${BASE}_[0-9]+$EXT" | \
    sed -E "s/^${BASE}_([0-9]+)\.png$/\1/" | sort -n | tail -n 1)

if [ -n "$max_counter" ]; then
    COUNTER=$((max_counter + 1))
fi

FILENAME="$DIR/${BASE}_$COUNTER$EXT"

echo "Saving screenshot as: $FILENAME"

# Screenshot: full screen or selection
if [ "$1" == "-s" ]; then
    # Region selection with slurp
    grim -g "$(slurp)" "$FILENAME"
else
    # Fullscreen screenshot
    grim "$FILENAME"
fi

wl-copy < "$FILENAME"
