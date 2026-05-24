#!/usr/bin/env bash

read_cpu() {
    grep '^cpu ' /proc/stat | awk '{
        idle=$5
        total=0
        for (i=2; i<=NF; i++) total += $i
            print idle, total

        }'
}

set -- $(read_cpu)
idle1=$1
total1=$2

sleep 1

set -- $(read_cpu)
idle2=$1
total2=$2

idle_diff=$((idle2 - idle1))
total_diff=$((total2 - total1))

usage=$(( (100 * (total_diff - idle_diff)) / total_diff ))

echo "P:${usage}%"
