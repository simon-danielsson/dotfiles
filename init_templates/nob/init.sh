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

# Check template exists
if [ ! -d "$template_dir" ]; then
    error "Template directory not found: $template_dir"
fi

# Prevent overwrite
if [ -e "$target_dir" ]; then
    error "Directory already exists: $target_dir"
fi

# Copy template
cp -r -- "$template_dir" "$target_dir" || {
    error "Failed to copy template"
}

# generate build.sh
touch $target_dir/build.sh
cat > "$target_dir/build.sh" <<EOF
#!/usr/bin/env bash

cd $target_dir
mkdir build 2>/dev/null
cc -o ./nob/nob ./nob/nob.c
./nob/nob
./build/main
EOF

# Make executable
chmod +x "$target_dir/build.sh" || {
    error "Failed to make build.sh executable"
}

# generate README.md
touch $target_dir/README.md
echo "## $name" >> $target_dir/README.md

# get latest version of nob.h from repo
cd $target_dir/nob
curl -O https://raw.githubusercontent.com/tsoding/nob.h/refs/heads/main/nob.h 2>/dev/null || {
    error "Failed to curl nob.h from the nob.h github repo"
}

# get latest version of analib.h from repo
mkdir $target_dir/src/libs
cd $target_dir/src/libs
curl -O https://raw.githubusercontent.com/simon-danielsson/analib.h/refs/heads/main/analib.h 2>/dev/null || {
    error "Failed to curl analib.h from the analib.h github repo"
}

# generate main.h
touch $target_dir/src/main.h
cat > "$target_dir/src/main.h" <<EOF
#define PRG_N "$name"
#define PRG_V "0.1.0"
#define PRG_L "Copyright © 2026 Simon Danielsson"
#define PRG_R "https://github.com/simon-danielsson/$name"

#define ANALIB_IMPLEMENTATION
#include "./libs/analib.h"
EOF

# remove init.sh from new project
rm $target_dir/init.sh

echo "Project \"$name\" has been generated: $target_dir"

