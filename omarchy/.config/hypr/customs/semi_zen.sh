#!/bin/bash

if pgrep -x waybar >/dev/null; then
  pkill -x waybar
else
  uwsm-app -- waybar >/dev/null 2>&1 &
fi

hyprctl dispatch setprop "address:$(hyprctl activewindow -j | jq -r '.address')" opaque toggle
hyprctl dispatch fullscreen 1

