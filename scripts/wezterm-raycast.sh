#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Wezterm
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🚀

WEZTERM="$HOME/dev/source_code/wezterm/target/release/wezterm"

open -g -a "$WEZTERM" --args start

osascript <<'APPLESCRIPT'
tell application "System Events"
  repeat 20 times
    set matches to processes whose name contains "wezterm"
    if (count of matches) > 0 then
      set frontmost of item 1 of matches to true
      exit repeat
    end if
    delay 0.05
  end repeat
end tell
APPLESCRIPT
