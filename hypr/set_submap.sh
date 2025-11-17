#!/usr/bin/env bash
# This script updates the current Hyprland mode for Quickshell/bar integration

mode="$1"
modefile="$HOME/.cache/hypr_mode"
hyprctl dispatch submap "$1"

# Write current mode to a file
mkdir -p "$(dirname "$modefile")"
echo -n "$mode" > "$modefile"
