#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME background.color=0xff2a2a33 label.shadow.drawing=off icon.shadow.drawing=off
else
  sketchybar --set $NAME background.color=0x00000000 label.shadow.drawing=off icon.shadow.drawing=off
fi

