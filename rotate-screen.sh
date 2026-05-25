#!/bin/bash

MONITOR="${MONITOR:-eDP-1}"
MODE="${MODE:-preferred}"
POSITION="${POSITION:-auto}"
SCALE="${SCALE:-1}"

# File to store rotation toggle state (0 = off, 1 = on)
TOGGLE_FILE="$HOME/.config/hypr/rotation-toggle"

# Ensure toggle file exists, default to enabled (1)
[ -f "$TOGGLE_FILE" ] || echo "1" > "$TOGGLE_FILE"

rotate() {
  local transform="$1"
  local inst_sig

  inst_sig=$(ls -1t "$XDG_RUNTIME_DIR/hypr" | head -1)
  export HYPRLAND_INSTANCE_SIGNATURE="$inst_sig"

  hyprctl eval "hl.monitor({ output = \"$MONITOR\", mode = \"$MODE\", position = \"$POSITION\", scale = \"$SCALE\", transform = $transform })"

  # Rotate touch input to match display
  hyprctl eval "hl.config({input = {touchdevice = {transform = $transform}, tablet = {transform = $transform, output = \"$MONITOR\"}}})"
}

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

  [ "$(cat "$TOGGLE_FILE")" -eq 0 ] && continue

  rotate "$TRANSFORM"
done
