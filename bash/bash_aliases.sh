# === website management ===

# create new blog post
alias blog="~/dotfiles/scripts/create-new-blog-entry-for-website.sh"

# cd to blog dir
alias blogdir="cd ~/dev/rust/website/src/blog/blog_entries/"

# cd website repo
alias website="cd ~/dev/rust/website/"

# === brakoll issue tracker ===

# short
alias b="brakoll"

unalias commit 2>/dev/null
commit() {
    local id="$1"
    brakoll cp $id
    brakoll close $id

    if command -v pbpaste >/dev/null; then
        clip=$(pbpaste)
    elif command -v xclip >/dev/null; then
        clip=$(xclip -o -selection clipboard)
    elif command -v wl-paste >/dev/null; then
        clip=$(wl-paste)
    fi

    git add --all
    git commit -a -m "$clip"
}

# === dev ===

# safe mv command
alias mv="mv -i"

# vim config
alias vimconf="cd ~/dotfiles/nvim/.config/nvim"

# vim pack
alias vimpack="cd ~/.local/share/nvim/site/pack/core/opt"

# neovim
NVIM="bob run stable"
alias nvimstable=$NVIM

NVIMS="VIMRUNTIME=/Users/simondanielsson/dev/source_code/neovim/runtime /Users/simondanielsson/dev/source_code/neovim/build/bin/nvim"
alias nvim=$NVIMS

# create new cmake project derived from template
cinit() {
    if [ -z "$1" ]; then
        echo "Usage: cinit <project_name>"
        echo "Creates a new C project from template and regenerates build.sh."
        return 1
    fi

    local name="$1"
    local template_dir="$HOME/dev/c/[templates]/template"
    local target_dir="$HOME/dev/c/$name"
    local build_file="$target_dir/build.sh"

    if [ ! -d "$template_dir" ]; then
        echo "Error: Template directory not found: $template_dir"
        return 1
    fi

    if [ -e "$target_dir" ]; then
        echo "Error: Directory already exists: $target_dir"
        return 1
    fi

    cp -r -- "$template_dir" "$target_dir" || {
        echo "Error: Failed to copy template"
        return 1
    }

    cat > "$build_file" <<EOF
#!/usr/bin/env bash
set -e

project="$name"

cd "\$HOME/dev/c/\$project"
cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=1
cmake --build build
"\$HOME/dev/c/\$project/build/\$project"
EOF

    chmod +x "$build_file" || {
        echo "Error: Failed to make build.sh executable"
        return 1
    }

    echo "Project '$name' created at $target_dir"
}

# === general ===

alias exti="exit"
alias xti="exit"

jump() {
  local entries=(
    $'config - dotfiles\t'"$HOME/dotfiles"
    $'person - notes\t'"$HOME/notes"
    $'config - nvim\t'"$HOME/dotfiles/nvim/.config/nvim"
    $'source - nvim\t'"$HOME/dev/source_code/neovim"
    $'develo - rust\t'"$HOME/dev/rust"
  )

  local selected label target

  selected="$(
    printf '%s\n' "${entries[@]}" \
      | fzf --prompt="shortcut > " \
            --height=40% \
            --reverse \
            --border \
            --delimiter=$'\t' \
            --with-nth=1
  )" || return

  label="${selected%%$'\t'*}"
  target="${selected#*$'\t'}"

  # Expand ~ if used
  eval "target=\"$target\""

  if [[ -d "$target" ]]; then
    cd "$target" || return
  elif [[ -f "$target" ]]; then
    nvim "$target"
  else
    printf 'Not found: %s\n' "$target" >&2
    return 1
  fi
}

# get size of current dir
size() {
    dir_size=$(du -sh . | awk '{print $1}')
    echo "Current directory size: $dir_size"
}

# add to clipboard
alias clip="pbcopy"

# emoji picker
EM_PICKER="/Users/simondanielsson/dotfiles/scripts/emoji-picker.sh"
alias emoji=$EM_PICKER
alias em=$EM_PICKER

# devicon picker
DEV_PICKER="/Users/simondanielsson/dotfiles/scripts/devicon-picker.sh"
alias devicon=$DEV_PICKER
alias dev=$DEV_PICKER

# source .bashrc
alias sbash="source ~/.bashrc"

# neofetch (doubles as clear and go back to home dir)
alias nf="cd && clear && neofetch"

# terminal cheat lookup
cheat() {
    curl cheat.sh/$@
}

# shorten url
shorten() {
    curl -F url=$@ https://shorta.link
}

# define word
define() {
    curl dict.org/d:$@
}

# === journal ===

journal() {
    local today=$(date +"%Y-%m-%d")
    local dir="$HOME/journal"
    local file="$dir/${today}.md"
    local template="$dir/template.md"
    mkdir -p "$dir"
    # only copy template if the file doesn't already exist
    if [ ! -f "$file" ]; then
        if [ -f "$template" ]; then
            cp "$template" "$file"
        else
            touch "$file"
        fi
    fi
    nvim "$file"
}

# === notes ===

alias notes="cd ~/notes"

n() {
    local name="$*"
    local today
    today=$(date +"%Y-%m-%d")
    local dir="$HOME/notes"
    # if no arg given, default to "note"
    if [ -z "$name" ]; then
        name="note"
    fi
    # format arg
    name=$(echo "$name" | xargs | tr -s ' ' '-' | sed 's/-$//' | tr '[:upper:]' '[:lower:]')
    local file="$dir/${name}_${today}.md"
    mkdir -p "$dir"
    # create empty file if it doesn't exist
    [ -f "$file" ] || touch "$file"
    nvim "$file"
}

# === directories and search ]===

# copy working directory - add path of pwd to clipboard
alias cwd='pwd | pbcopy'

# recursively delete all .DS_Store files in current folder
alias ds='find . -name ".DS_Store" -type f -delete'

# ls default
alias ls='ls -paGAoh -D "%d-%m-%Y %H:%M" '

# my own worse version of ls
alias ta="ta -a "

# grep using fzf
unalias g 2>/dev/null
g() {
    local query="${*:-}"

    local -a rg_opts=(
        --column
        --line-number
        --no-heading
        --color=never
        --smart-case
        --hidden
        --glob '!.git/'
        --glob '!target/'
        --glob '!node_modules/'
        --glob '!.gitignore'
        --glob '!*.lock'
    )

    local reload_cmd
    reload_cmd="rg $(printf "%q " "${rg_opts[@]}") {q} . 2>/dev/null || true"

    fzf --disabled \
        --query "$query" \
        --delimiter : \
        --preview 'bat --style=numbers --highlight-line {2} {1}' \
        --preview-window '~3,+{2}/2' \
        --bind "start:reload:$reload_cmd" \
        --bind "change:reload:$reload_cmd" \
        --bind 'enter:become(nvim "+call cursor({2},{3})" -- {1})'
}

# local search from current directory
unalias s 2>/dev/null
s() {
    local target
    target=$(fd --type f --type d --hidden | fzf --preview='[[ -d {} ]] && exa -al {} || bat --style=numbers {}') || return
    if [[ -d $target ]]; then
        cd "$target"
    elif [[ -f $target ]]; then
        nvim "$target"
    fi
}

# global search from home directory
unalias ss 2>/dev/null
ss() {
    local target
    target=$(fd --type f --type d --hidden . ~ | fzf --preview='[[ -d {} ]] && exa -al {} || bat --style=numbers {}') || return
    if [[ -d $target ]]; then
        cd "$target"
    elif [[ -f $target ]]; then
        nvim "$target"
    fi
}
