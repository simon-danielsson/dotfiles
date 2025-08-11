typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
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

source <(fzf --zsh)

if [ -f ~/dotfiles/zsh_aliases.zsh ]; then
        source ~/dotfiles/zsh_aliases.zsh
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Auto-start or attach to tmux session "main" only if not already inside tmux
if [ -z "$TMUX" ]; then
        if tmux has-session -t main 2>/dev/null; then
                exec tmux attach-session -t main
        else
                exec tmux new-session -s main
        fi
fi

eval "$(zoxide init zsh)"
