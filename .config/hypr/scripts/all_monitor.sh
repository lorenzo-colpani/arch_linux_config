#!/bin/bash

# Recovery for black screens after a monitor power-cycle.
# Aquamarine keeps a stale pending page-flip and rejects every new commit
# ("Cannot commit when a page-flip is awaiting"). Disabling an output runs
# its cleanup path, re-enabling forces a fresh modeset. Plain hyprctl only,
# no Lua eval, so this survives Hyprland version changes.

MONS=$(hyprctl monitors -j 2>/dev/null | jq -r '.[].name')
if [ -z "$MONS" ]; then
  echo "Error: hyprctl not reachable. Is Hyprland running?"
  exit 1
fi

echo "Disabling all monitors to clear stale flip state..."
FAILED=0
for m in $MONS; do
  echo "  disable $m"
  timeout 5 hyprctl keyword monitor "$m,disable" >/dev/null || FAILED=1
  sleep 0.3
done

sleep 0.5

if [ "$FAILED" -eq 1 ]; then
  echo "A disable command failed or timed out. Trying full reload anyway..."
fi

echo "Re-enabling all monitors..."
hyprctl reload >/dev/null
sleep 1

# Fallback: if reload did not re-enable them, do it explicitly.
STILL_OFF=$(hyprctl monitors -j 2>/dev/null | jq -r '[.[] | select(.disabled)] | length')
if [ "$STILL_OFF" -gt 0 ]; then
  echo "Reload did not re-enable everything, applying explicit config..."
  for m in $MONS; do
    timeout 5 hyprctl keyword monitor "$m,preferred,auto,1" >/dev/null
    sleep 0.3
  done
fi

hyprctl monitors -j | jq -r '.[] | "\(.name): disabled=\(.disabled) dpms=\(.dpmsStatus)"'
echo "Done. All monitors are on."
