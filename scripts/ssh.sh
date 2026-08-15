#!/usr/bin/env bash

set -euo pipefail

SSH_CONFIG="${SSH_CONFIG:-$HOME/.ssh/config}"

hosts=$(grep -E "^Host " "$SSH_CONFIG" | \
        awk '{print $2}' | \
        grep -v '^\*$' | \
        sort -u)

selected_host=$(echo "$hosts" | fzf \
    --prompt="SSH  " \
    --height=40% \
    --layout=reverse \
    --border \
    --select-1 \
    --bind='tab:down,btab:up')

exec ssh "$selected_host"


