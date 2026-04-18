#!/usr/bin/env bash

set -e

# Usage check
if [ -z "$1" ]; then
    echo "Usage: cinit <project_name>"
    echo "Creates a new C project from template and regenerates build.sh."
    exit 1
fi

name="$1"
template_dir="$HOME/dev/[templates]/cmakelists"
target_dir="$HOME/dev/c/$name"
build_file="$target_dir/build.sh"

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

# Generate build.sh
cat > "$build_file" <<EOF
#!/usr/bin/env bash
set -e

project="$name"

cd "\$HOME/dev/c/\$project"
cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=1
cmake --build build
"\$HOME/dev/c/\$project/build/\$project"
EOF

# Make executable
chmod +x "$build_file" || {
    echo "Error: Failed to make build.sh executable"
    exit 1
}

echo "Project '$name' created at $target_dir"

