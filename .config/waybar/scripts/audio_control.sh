#!/bin/bash

# A corrected, more robust script to display and switch audio outputs.

# --- This function displays the friendly name of the current default sink ---
display_current_device() {
  default_sink_name=$(pactl get-default-sink)
  # Find the line with the description for the default sink and extract it
  pactl list sinks | grep -A 5 "Name: $default_sink_name" | grep 'Description:' | sed 's/^[[:space:]]*Description: //'
}

# --- This function lets the user switch to a new sink ---
switch_device() {
  # Get just the descriptions of all available sinks
  descriptions=$(pactl list sinks | grep 'Description:' | cut -d' ' -f2-)

  # Use fuzzel to present the friendly descriptions to the user
  chosen_desc=$(echo "$descriptions" | fuzzel --dmenu --prompt="Select Audio Output: ")

  # If the user made a choice (the line is not empty)
  if [ -n "$chosen_desc" ]; then
    # Find the technical name that corresponds to the chosen friendly description
    # We do this by finding the description, and then getting the line *before* it, which is the Name.
    chosen_name=$(pactl list sinks | grep -B 1 "Description: $chosen_desc" | grep 'Name:' | cut -d' ' -f2)

    # Set the chosen sink as the new default
    pactl set-default-sink "$chosen_name"
  fi
}

# --- Main script logic ---
if [ "$1" == "display" ]; then
  display_current_device
else
  # The default action is to switch
  switch_device
fi
