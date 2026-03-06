#!/usr/bin/env bash

set -euo pipefail

base_dir="$HOME/dev/rust/website/src/blog/blog_entries"

title=""
tags=""

usage() {
  echo "Usage:"
  echo "  blog -t Blog post title! -T test, rust"
  echo "  blog --title Blog post title! --tags test, rust"
  exit 1
}

trim_spaces() {
  sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//'
}

trim_trailing_commas() {
  sed -E 's/[[:space:]]*,+[[:space:]]*$//'
}

collect_until_next_flag() {
  local result=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -t|--title|-T|--tags)
        break
        ;;
      *)
        if [[ -n "$result" ]]; then
          result+=" "
        fi
        result+="$1"
        shift
        ;;
    esac
  done

  printf '%s\n' "$result"
  return 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -t|--title)
      shift
      [[ $# -gt 0 ]] || usage
      value="$(collect_until_next_flag "$@")"
      consumed_words=$(wc -w <<< "$value")
      title="$(printf '%s' "$value" | trim_spaces)"
      shift $consumed_words
      ;;
    -T|--tags)
      shift
      [[ $# -gt 0 ]] || usage
      value="$(collect_until_next_flag "$@")"
      consumed_words=$(wc -w <<< "$value")
      tags="$(printf '%s' "$value" | trim_spaces | trim_trailing_commas)"
      shift $consumed_words
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo "Unknown argument: $1"
      usage
      ;;
  esac
done

if [[ -z "$title" ]]; then
  echo "Error: title required (-t or --title)"
  usage
fi

# date for meta file
pretty_date="$(date +"%B %-d, %Y")"

# date slug for folder
slug_date="$(date +"%B %-d-%Y" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"

# convert title to slug
title_slug="$(
  printf '%s' "$title" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//; s/-+/-/g'
)"

folder_name="${title_slug}_${slug_date}"
post_file="${title_slug}.md"
post_dir="${base_dir}/${folder_name}"

mkdir -p "$post_dir"

cat > "${post_dir}/meta" <<EOF
title: $title
date: $pretty_date
tags: $tags
EOF

touch "${post_dir}/${post_file}"

nvim "${post_dir}/${post_file}"
