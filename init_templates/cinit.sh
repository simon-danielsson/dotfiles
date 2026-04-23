#!/usr/bin/env bash
#
# cinit.sh
# v0.1.0
#
# Copyright © 2026 Simon Danielsson
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files, to deal in the Software
# without restriction, including without limitation the rights to use, copy,
# modify, merge, publish, distribute, sublicense, and/or sell copies of the
# Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.
#
#

set -e

error() {
    echo "[ERROR] - $1"; exit 1
}

# Usage check
if [ -z "$1" ]; then
    echo "Generate a new C project:"
    echo "$ nob <project_name>"
    exit 1
fi

name="$1"
target_dir="$(pwd -P)/$name"
display_dir="$(printf '%s\n' "$target_dir" | sed "s#^$HOME#~#")"
current_date=$(date +"%F")

if [ -e "$target_dir" ]; then
    error "Directory already exists: $target_dir"
fi

mkdir -p "$target_dir"

# generate run (build script)
touch "$target_dir/run"
cat > "$target_dir/run" <<EOF
#!/usr/bin/env bash

SCRIPT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
cd "\$SCRIPT_DIR"

C1="\\033[1;34m"   # bold blue
C2="\\033[1;33m"   # bold yellow
CR="\\033[0m"      # reset

build() {
    mkdir -p build
    cc -o ./tools/nob/nob ./tools/nob/nob.c
    ./tools/nob/nob
}

run() {
    ./build/$name
}

todo() {
    ./tools/jobb/jobb ./src
}

doc() {
    echo "not implemented yet"
}

help() {
    printf "\\n"
    printf "\${C1}run\${CR}\\n"
    printf ": build project and run binary\\n"

    printf "\${C1}run \${C2}build\${CR}\\n"
    printf ": build project\\n"

    printf "\${C1}run \${C2}run\${CR}\\n"
    printf ": run binary\\n"

    printf "\${C1}run \${C2}doc\${CR}\\n"
    printf ": (via ./tools/cdok) generate docs and open in browser\\n"

    printf "\${C1}run \${C2}todo\${CR}\\n"
    printf ": (via ./tools/jobb) find todo statements in codebase\\n"

    printf "\${C1}run \${C2}help\${CR}\\n"
    printf ": display help\\n"
    printf "\\n"
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
  doc)
    doc
    ;;
  *)
    build
    run
    ;;
esac
EOF

# make dev executable
chmod +x "$target_dir/run" || {
    error "Failed to make dev executable"
}

# generate README.md
touch "$target_dir/README.md"; echo "## $name" >> "$target_dir/README.md"

# get latest version of nob.h from repo
mkdir -p "$target_dir/tools/nob"; cd "$target_dir/tools/nob"
curl -O https://raw.githubusercontent.com/tsoding/nob.h/refs/heads/main/nob.h || {
    error "Failed to curl nob.h from the nob.h github repo"
mkdir
}

# generate nob.c
touch "$target_dir/tools/nob/nob.c"
cat > "$target_dir/tools/nob/nob.c" <<EOF
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
curl -O https://raw.githubusercontent.com/simon-danielsson/analib.h/refs/heads/main/analib.h || {
    error "Failed to curl analib.h from the analib.h github repo"
}

# get latest version of analib.h from repo
cd "$target_dir/tools"
git clone https://github.com/simon-danielsson/jobb
cd jobb
./dev compile
mv ./build/main ..
cd "$target_dir/tools"
zip -r jobb.zip jobb
rm -rf jobb
mkdir -p jobb
mv main ./jobb/jobb
mv jobb.zip ./jobb/jobb-src_$current_date.zip

# generate main.h
mkdir -p "$target_dir/src"; touch "$target_dir/src/main.h"
cat > "$target_dir/src/main.h" <<EOF
// program variables
#define PRG_N "$name"
#define PRG_V "0.1.0"
#define PRG_L "Copyright © $(date +"%Y") Simon Danielsson"
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

// TODO: write a program
int main() {
    printf("Hello world!");
    return 0;
}
EOF

# generate license
touch "$target_dir/LICENSE"
cat > "$target_dir/LICENSE" <<EOF
Copyright © $(date +"%Y") Simon Danielsson

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

git init -b main
git add --all
git commit -m "init"

col_grn="\\033[1;32m"   # bold blue
col_rst="\\033[0m"      # reset

printf "\n${col_grn}Project \"$name\" was generated successfully!${col_rst}\n"
printf "\nTo get started, run the following commands:\ncd $display_dir\nrun help\n"

