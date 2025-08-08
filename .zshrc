typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
        source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"
export LESS='--mouse --wheel-lines=1'
export rmpc='/Users/simondanielsson/.cargo/bin'
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)
source $ZSH/oh-my-zsh.sh

# fzf
source <(fzf --zsh)

# folders and files
alias mkcd='mkdir -p "$1" && cd "$1"'
alias cleanempty='find . -type d -empty -delete'

# kill all nvim and tmux processes
alias q="/Users/simondanielsson/dev/bash-scripts/kill-nvim-and-tmux.sh"

# rust and cargo aliases
alias r="cargo run --release"
alias rc="cargo check"
alias rb="cargo build --release"
alias rd="cargo doc --open"

# python aliases
alias p="python3 *.py"

# vi to nvim
alias vi="nvim"

# start nvim with godotpipe
alias gvim="/Users/simondanielsson/dev/bash-scripts/start-nvim-with-godotpipe.sh"

# start godot and nvim with godotpipe
alias godot="/Users/simondanielsson/dev/bash-scripts/start-godot-and-nvim-together.sh"

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# launch "main" tmux session with neofetch
# /Users/simondanielsson/dev/bash-scripts/zsh-startup.sh
# Auto-start or attach to tmux session "main" only if not already inside tmux
if [ -z "$TMUX" ]; then
        if tmux has-session -t main 2>/dev/null; then
                exec tmux attach-session -t main
        else
                exec tmux new-session -s main
        fi
fi

eval "$(zoxide init zsh)"
