#!/usr/bin/env bash
set -e

error() {
    echo "[ERROR] - $1"; exit 1
}

# Usage check
if [ -z "$1" ]; then
    echo "Build a new C project with nob.h"; echo "Usage: nob <project_name>"
    exit 1
fi

name="$1"; target_dir="$(pwd)/$name"

if [ -e "$target_dir" ]; then
    error "Directory already exists: $target_dir"
fi

mkdir -p "$target_dir"

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
    ./build/$name
}

todo() {
    \$HOME/dotfiles/custom_bins/jobb ./src
}

doc() {
    echo "not implemented yet"
}

help() {
    echo "$ dev compile : compile project"
    echo "$ dev run     : run compiled binary"
    echo "$ dev         : compile & run"
    echo "$ dev doc     : generate documentation"
    echo "$ dev todo    : search for todo statements in source code"
    echo "$ dev help    : display help"
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
  format)
    format
    ;;
  todo)
    doc
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
touch "$target_dir/README.md"; echo "## $name" >> "$target_dir/README.md"

# get latest version of nob.h from repo
mkdir -p "$target_dir/nob"; cd "$target_dir/nob"
curl -O https://raw.githubusercontent.com/tsoding/nob.h/refs/heads/main/nob.h 2>/dev/null || {
    error "Failed to curl nob.h from the nob.h github repo"
mkdir
}

# generate nob.c
touch "$target_dir/nob/nob.c"
cat > "$target_dir/nob/nob.c" <<EOF
#define NOB_IMPLEMENTATION
#pragma GCC diagnostic ignored "-Wmissing-field-initializers"

#include "nob.h"
#include <stdlib.h>
#include <string.h>

#define BINARY_NAME "$name"
#define BUILD_FOLDER "./build/"
#define SRC_FOLDER "./src"

typedef struct {
    char **items;
    size_t count;
    size_t capacity;
} Path_List;

static bool has_c_extension(const char *path) {
    size_t len = strlen(path);
    return len >= 2 && strcmp(path + len - 2, ".c") == 0;
}

static void path_list_append(Path_List *arr, const char *str) {
    if (arr->count >= arr->capacity) {
        size_t new_cap = arr->capacity == 0 ? 8 : arr->capacity * 2;
        char **new_items = realloc(arr->items, new_cap * sizeof(char *));
        NOB_ASSERT(new_items != NULL);
        arr->items = new_items;
        arr->capacity = new_cap;
    }
    arr->items[arr->count++] = strdup(str);
    NOB_ASSERT(arr->items[arr->count - 1] != NULL);
}

static bool collect_files(Nob_Walk_Entry entry) {
    Path_List *arr = (Path_List *)entry.data;
    if (entry.type == FILE_REGULAR && has_c_extension(entry.path)) {
        path_list_append(arr, entry.path);
    }
    return true;
}

int main(int argc, char **argv) {
    NOB_GO_REBUILD_URSELF(argc, argv);

    Nob_Cmd cmd = {0};

    nob_cc(&cmd);
    nob_cc_flags(&cmd);
    nob_cmd_append(&cmd, "-o", BUILD_FOLDER BINARY_NAME);

    Path_List files = {0};
    nob_walk_dir(SRC_FOLDER, collect_files, &files);

    for (size_t i = 0; i < files.count; i++) {
        nob_cmd_append(&cmd, files.items[i]);
    }

    if (!nob_cmd_run(&cmd))
        return 1;

    for (size_t i = 0; i < files.count; i++) {
        free(files.items[i]);
    }
    free(files.items);

    return 0;
}
EOF

# get latest version of analib.h from repo
mkdir -p "$target_dir/src/libs"; cd "$target_dir/src/libs"
curl -O https://raw.githubusercontent.com/simon-danielsson/analib.h/refs/heads/main/analib.h 2>/dev/null || {
    error "Failed to curl analib.h from the analib.h github repo"
}

# generate main.h
mkdir -p "$target_dir/src"; touch "$target_dir/src/main.h"
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

# generate main.c
mkdir -p "$target_dir/src"; touch "$target_dir/src/main.c"
cat > "$target_dir/src/main.c" <<EOF
#include "main.h"

int main() {
    printf("Hello world!");
    return 0;
}
EOF

# generate license
touch "$target_dir/LICENSE"
cat > "$target_dir/LICENSE" <<EOF
Copyright © 2026 Simon Danielsson

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files, to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
EOF

# initalize git
cd "$target_dir"; touch "$target_dir/.gitignore"
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

