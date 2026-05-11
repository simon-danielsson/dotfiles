#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Wezterm
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🖥

WEZTERM="$HOME/dev/source_code/wezterm/target/release/wezterm"

"$WEZTERM" start &

sleep 0.1

osascript <<'APPLESCRIPT'
tell application "System Events"
  set frontmost of first process whose unix id is not 0 and name contains "wezterm" to true
end tell
APPLESCRIPT

