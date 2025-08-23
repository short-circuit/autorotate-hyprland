#!/bin/bash

TOGGLE_FILE="$HOME/.config/hypr/rotation-toggle"

if [ "$(cat "$TOGGLE_FILE")" -eq 1 ]; then
  echo "0" > "$TOGGLE_FILE"
  notify-send "Auto-rotation disabled"
else
  echo "1" > "$TOGGLE_FILE"
  notify-send "Auto-rotation enabled"
fi
