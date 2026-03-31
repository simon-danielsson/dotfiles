# homebrew
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export LESS='--mouse --wheel-lines=1'
# bob nvim version manager
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
# cargo
. "$HOME/.cargo/env"
# manually installed binaries
export PATH="$PATH:/Users/simondanielsson/.local/bin"
# haskell
export PATH="$HOME/.ghcup/bin:$PATH"
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

