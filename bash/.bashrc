export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export LESS='--mouse --wheel-lines=1'
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
. "$HOME/.cargo/env"
export PATH="$PATH:/Users/simondanielsson/.local/bin"
export PATH="$HOME/.ghcup/bin:$PATH"

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

# source ~/bash_prompt.sh
# PROMPT_COMMAND='PS1="$(/Users/simondanielsson/dev/rust/raket/target/release/raket)"'
# PROMPT_COMMAND='PS1="$(raket)"'

# if [ -z "$TMUX" ]; then
# 	if tmux has-session -t main 2>/dev/null; then
# 		exec tmux attach-session -t main
# 	else
# 		tmux new-session -d -s main -c ~
# 		tmux new-window -t main -n system -c ~ "glances" || true
# 		tmux new-window -t main -n journal -c ~/journal "bash -i -c journal" || true
# 		tmux select-window -t main:1
# 		exec tmux attach-session -t main
# 	fi
# fi
