#!/usr/bin/env bash

ffplay -f avfoundation -fflags nobuffer -flags low_delay -framerate 30 -i "0" -window_title cam &>/dev/null &

