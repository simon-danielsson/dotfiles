#!/usr/bin/env bash

mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
mem_avail=$(grep MemAvailable /proc/meminfo | awk '{print $2}')

used=$((mem_total - mem_avail))

usage=$((100 * used / mem_total))

echo "R:${usage}%"

