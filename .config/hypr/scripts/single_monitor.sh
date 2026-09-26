#!/bin/bash

# Disable every monitor except the focused one.
# Uses plain 'hyprctl keyword monitor' instead of Lua eval.

CURRENT_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
OTHER_MONITORS=$(hyprctl monitors -j | jq -r ".[] | select(.name != \"$CURRENT_MONITOR\") | .name")

if [ -z "$OTHER_MONITORS" ]; then
  echo "Only one monitor ($CURRENT_MONITOR) is currently active. Nothing to disable."
  exit 0
fi

echo "Current monitor: $CURRENT_MONITOR"
echo "Monitors to disable: $OTHER_MONITORS"

for MONITOR in $OTHER_MONITORS; do
  echo "Disabling monitor: $MONITOR"
  timeout 5 hyprctl keyword monitor "$MONITOR,disable" >/dev/null
done

echo "Done. All monitors except $CURRENT_MONITOR are disabled."
