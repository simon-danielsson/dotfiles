# less config
export LESS='--mouse --wheel-lines=1'

# homebrew
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
# bob nvim version manager
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
# cargo
. "$HOME/.cargo/env"
# manually installed binaries
export PATH="$PATH:/Users/simondanielsson/.local/bin"
# haskell
export PATH="$HOME/.ghcup/bin:$PATH"

# odin ols
export PATH="$HOME/dotfiles/nvim/.config/nvim/lsp/ols:$PATH"

# sqlite
export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"

# emacs
export PATH="$HOME/.config/emacs/bin:$PATH"
export PATH="/Applications/MacPorts/Emacs.app/Contents/MacOS:$PATH"

if [ -f ~/bash_aliases.sh ]; then
    source ~/bash_aliases.sh
fi

_raket() {
    local last_status=$?
    PS1="$(raket --status="$last_status")"
}
PROMPT_COMMAND=_raket

# _raket() {
#     local last_status=$?
#     PS1="$(/Users/simondanielsson/dev/rust/raket/target/release/raket --status="$last_status")"
# }
# PROMPT_COMMAND=_raket

# man page colors

export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;33;44m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[4;1;32m'
export LESS_TERMCAP_mr=$'\e[7m'
export LESS_TERMCAP_mh=$'\e[2m'
export LESS_TERMCAP_ZN=$'\e[74m'
export LESS_TERMCAP_ZV=$'\e[75m'
export LESS_TERMCAP_ZO=$'\e[73m'
export LESS_TERMCAP_ZW=$'\e[75m'
export MANPAGER='less'
