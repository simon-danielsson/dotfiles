#!/usr/bin/env bash

run() {
    local dir="$(pwd)"

    while [[ "$dir" != "$HOME" ]]; do
        if [[ -f "$dir/run.py" ]]; then
            (cd "$dir" && ./run.py "$@")
            return
        fi
        dir="$(dirname "$dir")"
    done

    echo "no project root found" >&2
    return 1
}

cinitraw() {
    cp $HOME/dev/python/c_template/init.py .
    chmod +x init.py
    cp -R $HOME/dev/python/c_template/cinit_temp .
    ./init.py $1 "$2"
    command rm init.py
    command rm -rf cinit_temp

}

cinit() {
    file="init.py"
    curl -O https://raw.githubusercontent.com/simon-danielsson/c_template/refs/heads/main/"$file" || {
        echo "failed to curl $file" >&2
        exit 1
    }
    curl -L https://github.com/simon-danielsson/c_template/archive/refs/heads/main.tar.gz \
    | tar -xz --strip-components=1 c_template-main/cinit_temp
    chmod +x ./"$file"
    ./"$file" $1 "$2"
    command rm "$file"
    command rm -rf cinit_temp
}

$@
