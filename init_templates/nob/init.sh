#!/usr/bin/env bash

set -e

error() {
    echo "[ERROR] - $1"
    exit 1
}

# Usage check
if [ -z "$1" ]; then
    echo "Descr: Builds a new C project with the nob build-system."
    echo "Usage: nob <project_name>"
    exit 1
fi

name="$1"
template_dir="$HOME/dotfiles/init_templates/nob"
target_dir="$(pwd)/$name"

# check if template exists
if [ ! -d "$template_dir" ]; then
    error "Template directory not found: $template_dir"
fi

# prevent overwrite
if [ -e "$target_dir" ]; then
    error "Directory already exists: $target_dir"
fi

# copy template
cp -r -- "$template_dir" "$target_dir" || {
    error "Failed to copy template"
}

# generate dev (build script)
touch "$target_dir/dev"
cat > "$target_dir/dev" <<EOF
#!/usr/bin/env bash

SCRIPT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
cd "\$SCRIPT_DIR"

build() {
    mkdir -p build
    cc -o ./nob/nob ./nob/nob.c
    ./nob/nob
}

run() {
    ./build/main
}

help() {
    echo "$ dev compile : compile project"
    echo "$ dev run     : run compiled binary"
    echo "$ dev         : compile/run"
    echo "$ dev help    : display help"
}

todo() {
    jobb ./src
}

case "\$1" in
  build)
    build
    ;;
  run)
    build
    run
    ;;
  help)
    help
    ;;
  todo)
    todo
    ;;
  *)
    build
    run
    ;;
esac
EOF

# make dev executable
chmod +x "$target_dir/dev" || {
    error "Failed to make dev executable"
}

# generate README.md
touch "$target_dir/README.md"
echo "## $name" >> "$target_dir/README.md"

# get latest version of nob.h from repo
cd "$target_dir/nob"
curl -O https://raw.githubusercontent.com/tsoding/nob.h/refs/heads/main/nob.h 2>/dev/null || {
    error "Failed to curl nob.h from the nob.h github repo"
}

# get latest version of analib.h from repo
mkdir "$target_dir/src/libs"
cd "$target_dir/src/libs"
curl -O https://raw.githubusercontent.com/simon-danielsson/analib.h/refs/heads/main/analib.h 2>/dev/null || {
    error "Failed to curl analib.h from the analib.h github repo"
}

# generate main.h
touch "$target_dir/src/main.h"
cat > "$target_dir/src/main.h" <<EOF
// program variables
#define PRG_N "$name"
#define PRG_V "0.1.0"
#define PRG_L "Copyright © 2026 Simon Danielsson"
#define PRG_R "https://github.com/simon-danielsson/$name"

// global includes
#define ANALIB_IMPLEMENTATION
#include "./libs/analib.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

// diagnostics
#pragma GCC diagnostic ignored "-Wunused-variable"
EOF

# remove init.sh from new project
rm "$target_dir/init.sh"

# initalize git
cd "$target_dir"
touch "$target_dir/.gitignore"
cat > "$target_dir/.gitignore" <<EOF
build.sh
nob/nob
/build
/build/*
.DS_Store
EOF

git init -b main > /dev/null 2>&1
git add --all > /dev/null 2>&1
git commit -m "init" > /dev/null 2>&1

echo "Project \"$name\" has been generated: $target_dir"

