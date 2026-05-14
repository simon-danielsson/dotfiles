#!/usr/bin/env bash

set -xe

error() {
    echo "[ERROR] - $1"; exit 1
}

name="$1"
target_dir="$(pwd -P)/$name"
current_date=$(date +"%F")

if [ -e "$target_dir" ]; then
    error "Directory already exists: $target_dir"
fi

# run
mkdir -p "$target_dir"; touch "$target_dir/run"
cat > "$target_dir/run" <<EOF
#!/usr/bin/env bash

# project variables -----------------------------------------------------------

PROJ_NAME="$name"
PROJ_REPO="https://github.com/simon-danielsson/\$PROJ_NAME"
AUTH="Simon Danielsson"
AUTH_CONT="contact@simondanielsson.se"
C_STD="gnu23"

AUTO_RUN=1 # run program after build (0|1)

C_FLAGS_DEBUG=( # debug & test build
    "-g"
    "-O0"
    "-DDEBUG"
    "-fsanitize=address"
    "-Wall"
    "-Wextra"
    "-Wpedantic"
    "-Wshadow"
    "-Werror=format-security"
)

C_FLAGS_RELEASE=( # release build
    "-flto"
    "-O2"
    "-DNDEBUG"
    "-Wextra"
)

# dir and date variables ------------------------------------------------------

ROOT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
current_date=\$(date +"%F")

# get git details -------------------------------------------------------------

if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    git_head_hash_short=\$(git rev-parse --short HEAD)
    git_head_hash_long=\$(git rev-parse HEAD)
else
    git_head_hash_short="nogit"; git_head_hash_long="0.0.0"
fi

get_version() {
    git describe --tags --abbrev=0 2>/dev/null || echo "v0.1.0"
}
VERSION="\$(get_version)"

ENV_FLAGS=(
    "-DENV_GITHASH=\"\${git_head_hash_long}\""
    "-DENV_GITTAG=\"\${VERSION}\""
    "-DENV_NAME=\"\${PROJ_NAME}\""
    "-DENV_AUTHOR=\"\${AUTH}\""
    "-DENV_CONTACT=\"\${AUTH_CONT}\""
    "-DENV_REPO=\"\${PROJ_REPO}\""
    "-std=\${C_STD}"
)

# build -----------------------------------------------------------------------

build() {
    local SRC_DIR; local C_FLAGS; local BUILD_DIR

    cd "\$ROOT_DIR"

    case "\$1" in
        debug)
            BUILD_DIR="\$ROOT_DIR/build/debug"; SRC_DIR="\$ROOT_DIR/src"
            C_FLAGS=(
                "\${C_FLAGS_DEBUG[@]}"
                "\${ENV_FLAGS[@]}"
            )
            ;;

        release)
            BUILD_DIR="\$ROOT_DIR/build/release"; SRC_DIR="\$ROOT_DIR/src"
            C_FLAGS=(
                "\${C_FLAGS_RELEASE[@]}"
                "\${ENV_FLAGS[@]}"
            )
            ;;

        test)
            BUILD_DIR="\$ROOT_DIR/build/test"; SRC_DIR="\$ROOT_DIR/test"
            C_FLAGS=(
                "\${C_FLAGS_DEBUG[@]}"
                "\${ENV_FLAGS[@]}"
            )
            ;;
    esac

    # collect source files
    FILES=()
    while IFS= read -r -d '' file; do
        FILES+=("\$file")
    done < <(find "\$SRC_DIR" \( -name "*.c" \) -type f -print0)

    # define bin
    local BIN_NAME="\$PROJ_NAME-\$VERSION-\$git_head_hash_short"

    # compile
    mkdir -p "\$BUILD_DIR"; cd \$ROOT_DIR
    gcc "\${C_FLAGS[@]}" "\${FILES[@]}" -o "\$BUILD_DIR"/"\$BIN_NAME"

    if [ "\$AUTO_RUN" -eq 1 ]; then
        "\$BUILD_DIR"/"\$BIN_NAME"
    fi

}

# help ------------------------------------------------------------------------

help() {
    local bold="\\u001b[1m"; local reset="\\x1b[0m"
    printf "\${bold}run release\${reset}\\n"
    printf "   src:  ./src\\n"
    printf "   dest: ./build/release\\n\\n"
    printf "\${bold}run debug\${reset}\\n"
    printf "   src:  ./src\\n"
    printf "   dest: ./build/debug\\n\\n"
    printf "\${bold}run test\${reset}\\n"
    printf "   src:  ./test\\n"
    printf "   dest: ./build/test\\n"
}

# arguments -------------------------------------------------------------------

if [ -z "\$1" ]; then
    build debug
else
    case "\$1" in
        release)
            build release ;;
        debug)
            build debug ;;
        test)
            build test ;;
        help)
            help ;;
        *)
            help; exit 1 ;;
    esac
fi
EOF

chmod +x "$target_dir/run" || {
    error "Failed to make run script executable"
}

# generate README.md
touch "$target_dir/README.md"; echo "## $name" >> "$target_dir/README.md"

# generate main.h
mkdir -p "$target_dir/src"; touch "$target_dir/src/main.h"
cat > "$target_dir/src/main.h" <<EOF
#ifndef MAIN_H
#define MAIN_H

#if defined(TEST)
#define BUILD_TEST 1
#else
#define BUILD_TEST 0
#endif

#if defined(NDEBUG)
#define BUILD_RELEASE 1
#define BUILD_DEBUG 0
#else
#define BUILD_RELEASE 0
#define BUILD_DEBUG 1
#endif

// standard libraries ---------------------------------------------------------

#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// semantics ------------------------------------------------------------------

typedef size_t usize;
typedef int8_t i8;
typedef uint8_t u8;
typedef int16_t i16;
typedef uint16_t u16;
typedef int32_t i32;
typedef uint32_t u32;
typedef int64_t i64;
typedef uint64_t u64;
typedef float f32;
typedef double f64;

// suppress warnings ----------------------------------------------------------

#if defined(__clang__)
#pragma clang diagnostic ignored "-Wunused-variable"
#pragma clang diagnostic ignored "-Wunused-but-set-variable"
#pragma clang diagnostic ignored "-Wunused-function"
#elif defined(__GNUC__)
#pragma GCC diagnostic ignored "-Wunused-variable"
#pragma GCC diagnostic ignored "-Wunused-but-set-variable"
#pragma GCC diagnostic ignored "-Wunused-function"
#endif

// project variables ----------------------------------------------------------

#ifndef ENV_NAME // project name
#define ENV_NAME "UNDEFINED"
#endif
#ifndef ENV_AUTHOR // project author
#define ENV_AUTHOR "UNDEFINED"
#endif
#ifndef ENV_CONTACT // author contact
#define ENV_CONTACT "UNDEFINED"
#endif
#ifndef ENV_GITHASH // git version hash
#define ENV_GITHASH "UNDEFINED"
#endif
#ifndef ENV_GITTAG // git release tag
#define ENV_GITTAG "UNDEFINED"
#endif
#ifndef ENV_REPO // git repo
#define ENV_REPO "UNDEFINED"
#endif

// logging --------------------------------------------------------------------

#define LOG_ANSI_RED "\x1b[4;31m"
#define LOG_ANSI_GREEN "\x1b[4;32m"
#define LOG_ANSI_YELLOW "\x1b[4;33m"
#define LOG_ANSI_BLUE "\x1b[4;34m"
#define LOG_ANSI_RESET "\x1b[0m"

#ifndef __FILE_NAME__
#define __FILE_NAME__ __FILE__
#endif

#define LOG_POS_DETAILS __FILE_NAME__, __LINE__, __func__
#define LOG_PREFIX ""

#if defined(NDEBUG)
#define ASSERT(cond, do_abort) ((void)0)
#define LOG(fmt, ...) ((void)0)
#else
#define ASSERT(cond, do_abort)                                                 \
    do {                                                                         \
        if ((cond)) {                                                              \
            fprintf(stderr, "%s%sSUCCESS%s %s [%s:%d %s]\n", LOG_PREFIX,             \
                    LOG_ANSI_GREEN, LOG_ANSI_RESET, #cond, LOG_POS_DETAILS);         \
        } else {                                                                   \
            fprintf(stderr, "%s%sFAILURE%s %s [%s:%d %s]\n", LOG_PREFIX,             \
                    LOG_ANSI_RED, LOG_ANSI_RESET, #cond, LOG_POS_DETAILS);           \
        }                                                                          \
        if (!(cond) && (do_abort)) {                                               \
            abort();                                                                 \
        }                                                                          \
    } while (0)

#define LOG(fmt, ...)                                                          \
    do {                                                                         \
        fprintf(stderr, "%s%sLOG%s %s [%s:%d %s]\n", LOG_PREFIX, LOG_ANSI_BLUE,    \
                LOG_ANSI_RESET, fmt __VA_OPT__(, ) __VA_ARGS__, LOG_POS_DETAILS);  \
    } while (0)

#endif

// not implemented (todo msg that aborts the program)
#define NOT_IMPL(fmt, ...)                                                     \
    do {                                                                         \
        fprintf(stderr, "%s%sNOT IMPL%s %s [%s:%d %s]\n", LOG_PREFIX,              \
                LOG_ANSI_YELLOW, LOG_ANSI_RESET, fmt __VA_OPT__(, ) __VA_ARGS__,   \
                LOG_POS_DETAILS);                                                  \
        abort();                                                                   \
    } while (0)

#define PANIC(fmt, ...)                                                        \
    do {                                                                         \
        fprintf(stderr, "%s%sPANIC%s %s [%s:%d %s]\n", LOG_PREFIX, LOG_ANSI_RED,   \
                LOG_ANSI_RESET, fmt __VA_OPT__(, ) __VA_ARGS__, LOG_POS_DETAILS);  \
        abort();                                                                   \
    } while (0)

#endif // MAIN_H
EOF

# generate main.c
mkdir -p "$target_dir/src"; touch "$target_dir/src/main.c"
cat > "$target_dir/src/main.c" <<EOF
#include "main.h"

i32 main(void) {
    printf("Hello, %s!\n", ENV_AUTHOR);
    return 0;
}
EOF

# generate tests folder
mkdir -p "$target_dir/test"; touch "$target_dir/test/test.c"
cat > "$target_dir/test/test.c" <<EOF
#include "../src/main.h"

i32 main(void) {
    printf("test");
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
nvim.log
/build
/build/*
.DS_Store
*.o
EOF

git init -b main
git add --all
git commit -m "init"
git tag v0.1.0
