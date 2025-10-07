#!/bin/bash

# 1. Get the names of all active monitors
ALL_MONITORS=$(hyprctl monitors -j | jq -r ".[] | .name")

# 2. Loop through the list of other monitors and disable each one
for MONITOR in $ALL_MONITORS; do
  echo "Enabling monitor: $MONITOR"
  hyprctl dispatch dpms on "$MONITOR"
done

echo "Done. All monitors are on."
