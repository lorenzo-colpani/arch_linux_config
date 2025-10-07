#!/bin/bash

# 1. Get the name of the currently active monitor
# hyprctl monitors -j outputs a JSON array of all active monitors.
# We filter for the one where "focused" is true and extract its "name".
CURRENT_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')

# 2. Get the names of all other active monitors
# Filter out the current monitor and extract the names of the rest.
OTHER_MONITORS=$(hyprctl monitors -j | jq -r ".[] | select(.name != \"$CURRENT_MONITOR\") | .name")

# 3. Check if there are other monitors to disable
if [ -z "$OTHER_MONITORS" ]; then
  echo "Only one monitor ($CURRENT_MONITOR) is currently active. Nothing to disable."
  exit 0
fi

echo "Current monitor: $CURRENT_MONITOR"
echo "Monitors to disable: $OTHER_MONITORS"

# 4. Loop through the list of other monitors and disable each one
for MONITOR in $OTHER_MONITORS; do
  echo "Disabling monitor: $MONITOR"
  # Use 'hyprctl keyword monitor' with the 'name, disable' syntax
  hyprctl dispatch dpms off "$MONITOR"
done

echo "Done. All monitors except $CURRENT_MONITOR are disabled."
