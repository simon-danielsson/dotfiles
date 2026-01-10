# ======================================================
# General
# ======================================================

# kill all nvim and tmux processes, and exit ghostty
alias q="/Users/simondanielsson/dotfiles/scripts/kill-nvim-and-tmux.sh"

# convert all jpg and png images in chosen folder into webp
alias webp="/Users/simondanielsson/dotfiles/scripts/conv-to-webp.sh"

# age sheet music to look older
alias agepdf="/Users/simondanielsson/dotfiles/scripts/age-pdf.sh"

# convert m4a to flac in a given folder
alias convflac="/Users/simondanielsson/dotfiles/scripts/convert-m4a-to-flac.sh"

# go to dotfiles
alias dotfiles="/Users/simondanielsson/dotfiles/scripts/go-to-dotfiles.sh"

# go to dotfiles
alias dotfiles="/Users/simondanielsson/dotfiles/scripts/go-to-dotfiles.sh"

alias anna="/Users/simondanielsson/dotfiles/executables/anna"
alias pass="/Users/simondanielsson/dotfiles/executables/passgen"

# ======================================================
# Rust
# ======================================================

alias r="cargo run --release"
alias rd="cargo doc --open"

cargodoc() {
        cargo doc --quiet
        crate=$(basename "$(pwd)")
        tmux new-window "w3m target/doc/$crate/index.html | less; tmux kill-window"
}

# ======================================================
# Python
# ======================================================

alias p="python3 *.py"

# ======================================================
# Neovim
# ======================================================

alias gv="/Users/simondanielsson/dotfiles/scripts/start-nvim-with-godotpipe.sh"
alias gd="/Users/simondanielsson/dotfiles/scripts/start-godot-and-nvim-together.sh"

# ======================================================
# Typst
# ======================================================

journal() {
        local today=$(date +"%Y-%m-%d")
        local dir="$HOME/journal"
        local file="$dir/${today}.typ"
        local template="$dir/template.typ"
        mkdir -p "$dir"
        # Only copy template if the file doesn't already exist
        if [ ! -f "$file" ]; then
                if [ -f "$template" ]; then
                        cp "$template" "$file"
                else
                        touch "$file"
                fi
        fi
        nvim "$file"
}

# ======================================================
# Notes
# ======================================================

alias notes="cd ~/notes"

n() {
        local name="$*"
        local today
        today=$(date +"%Y-%m-%d")
        local dir="$HOME/notes"
        # If no name given, default to "note"
        if [ -z "$name" ]; then
                name="note"
        fi
        # Trim whitespace, replace multiple spaces with a single '-', strip trailing '-',
        # and convert to lowercase
        name=$(echo "$name" | xargs | tr -s ' ' '-' | sed 's/-$//' | tr '[:upper:]' '[:lower:]')
        local file="$dir/${name}_${today}.md"
        mkdir -p "$dir"
        # Create empty file if it doesn't exist
        [ -f "$file" ] || touch "$file"
        nvim "$file"
}

# ======================================================
# Directories & Search
# ======================================================

# eza (better ls)
alias ls="eza --color=always --icons --group-directories-first --git --no-time --no-permissions"

# Local search from current directory
unalias s 2>/dev/null
s() {
        local target
        target=$(fd --type f --type d --hidden | fzf --preview='[[ -d {} ]] && exa -al --color=always {} || bat --style=numbers --color=always {}') || return
        if [[ -d $target ]]; then
                cd "$target"
        elif [[ -f $target ]]; then
                nvim "$target"
        fi
}

# Global search from home directory
unalias ss 2>/dev/null
ss() {
        local target
        target=$(fd --type f --type d --hidden . ~ | fzf --preview='[[ -d {} ]] && exa -al --color=always {} || bat --style=numbers --color=always {}') || return
        if [[ -d $target ]]; then
                cd "$target"
        elif [[ -f $target ]]; then
                nvim "$target"
        fi
}
