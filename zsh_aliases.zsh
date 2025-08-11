# ======================================================
# General
# ======================================================

# kill all nvim and tmux processes, and exit ghostty
alias q="/Users/simondanielsson/dotfiles/scripts/kill-nvim-and-tmux.sh"

# ======================================================
# Rust
# ======================================================

alias r="cargo run --release"
alias rc="cargo check"
alias rb="cargo build --release"
alias rd="cargo doc --open"

# ======================================================
# Python
# ======================================================

alias p="python3 *.py"

# ======================================================
# Neovim
# ======================================================

alias n="nvim"
# start nvim with godotpipe
alias gvim="/Users/simondanielsson/dotfiles/scripts/start-nvim-with-godotpipe.sh"
# start godot and nvim with godotpipe
alias godot="/Users/simondanielsson/dotfiles/scripts/start-godot-and-nvim-together.sh"

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
