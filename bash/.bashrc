export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export LESS='--mouse --wheel-lines=1'
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
. "$HOME/.cargo/env"

if [ -f ~/bash_aliases.sh ]; then
	source ~/bash_aliases.sh
fi

source ~/bash_prompt.sh

if [ -z "$TMUX" ]; then
	if tmux has-session -t main 2>/dev/null; then
		exec tmux attach-session -t main
	else
		tmux new-session -d -s main -c ~
		tmux new-window -t main -n notes -c ~/notes || true
		tmux new-window -t main -n system -c ~ "glances" || true
		# tmux new-window -t main -n journal -c ~/journal "zsh -i -c journal" || true
		# tmux new-window -t main -n music -c ~/dev "stim" || true
		tmux select-window -t main:1
		exec tmux attach-session -t main
	fi
fi


# Created by `pipx` on 2026-01-21 06:06:30
export PATH="$PATH:/Users/simondanielsson/.local/bin"
