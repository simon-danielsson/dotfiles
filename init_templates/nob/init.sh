#!/usr/bin/env bash

set -e

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
    echo "Error: Failed to make build.sh executable"
    exit 1
}

# generate README.md
touch $target_dir/README.md
echo "## $name" >> $target_dir/README.md

echo "Project '$name' created at $target_dir"

rm $target_dir/init.sh
