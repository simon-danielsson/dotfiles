# ======================================================
# General
# ======================================================

# kill all nvim and tmux processes, and exit ghostty
alias q="/Users/simondanielsson/dotfiles/scripts/kill-nvim-and-tmux.sh"

# ======================================================
# Rust
# ======================================================

alias r="cargo run --release"
alias rd="cargo doc --open"

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
