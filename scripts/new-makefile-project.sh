#!/usr/bin/env bash

set -e

# Usage check
if [ -z "$1" ]; then
    echo "Usage: cinit <project_name>"
    echo "Creates a new C project from template and regenerates build.sh."
    exit 1
fi

name="$1"
template_dir="$HOME/dev/[templates]/makefile"
target_dir="$HOME/dev/c/$name"
build_file="$target_dir/build.sh"
make_file="$target_dir/Makefile"

# Check template exists
if [ ! -d "$template_dir" ]; then
    echo "Error: Template directory not found: $template_dir"
    exit 1
fi

# Prevent overwrite
if [ -e "$target_dir" ]; then
    echo "Error: Directory already exists: $target_dir"
    exit 1
fi

# Copy template
cp -r -- "$template_dir" "$target_dir" || {
    echo "Error: Failed to copy template"
    exit 1
}

cat > "$make_file" <<EOF
CFLAGS = -Wall -Wextra -std=c23 -pedantic -ggdb
ROOT = \$(HOME)/dev/c/$name
PROJECT = \$(notdir \$(ROOT))
SRC = \$(ROOT)/src
BUILD = \$(ROOT)/build

.PHONY: build clean

build: \$(BUILD)/\$(PROJECT)

\$(BUILD)/main.o: \$(SRC)/main.c
	mkdir -p \$(BUILD)
	gcc \$(CFLAGS) -c \$< -o \$@

\$(BUILD)/\$(PROJECT): \$(BUILD)/main.o
	gcc \$(CFLAGS) $^ -o \$@

clean:
	find . -name "*.o" -type f -delete

EOF

# Generate build.sh
cat > "$build_file" <<EOF
#!/usr/bin/env bash

# variables
project="$name"
root="\$HOME/dev/c/\$project"

# script

cd \$root
make
make clean
\$root/build/\$project

EOF

# Make executable
chmod +x "$build_file" || {
    echo "Error: Failed to make build.sh executable"
    exit 1
}

echo "Project '$name' created at $target_dir"
