#!/bin/bash

MONITOR="eDP-1"
MODE="preferred"
POSITION="auto"
SCALE="1"

# File to store rotation toggle state (0 = off, 1 = on)
TOGGLE_FILE="$HOME/.config/hypr/rotation-toggle"

# Ensure toggle file exists, default to enabled (1)
[ -f "$TOGGLE_FILE" ] || echo "1" > "$TOGGLE_FILE"

monitor-sensor | while read -r line; do
  if [[ $line == *"orientation changed: normal"* ]]; then
    TRANSFORM=0
  elif [[ $line == *"orientation changed: right-up"* ]]; then
    TRANSFORM=3
  elif [[ $line == *"orientation changed: left-up"* ]]; then
    TRANSFORM=1
  elif [[ $line == *"orientation changed: bottom-up"* ]]; then
    TRANSFORM=2
  else
    continue
  fi

  hyprctl keyword monitor "$MONITOR,$MODE,$POSITION,$SCALE,transform,$TRANSFORM"
done
