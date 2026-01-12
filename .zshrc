export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export LESS='--mouse --wheel-lines=1'

. "$HOME/.cargo/env"
source <(fzf --zsh)

if [ -f ~/dotfiles/zsh_aliases.zsh ]; then
	source ~/dotfiles/zsh_aliases.zsh
fi
ZSH_THEME=""
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"

source ~/dotfiles/zsh-prompt.zsh

eval "$(zoxide init zsh)"

if [ -z "$TMUX" ]; then
	if tmux has-session -t main 2>/dev/null; then
		exec tmux attach-session -t main
	else
		tmux new-session -d -s main -c ~/dev
		# tmux new-window -t main -n opencode -c ~/dev "opencode" 2>/dev/null || true
		# tmux new-window -t main -n journal -c ~/journal "zsh -i -c journal" || true
		# tmux new-window -t main -n music -c ~/dev "stim" || true
		tmux select-window -t main:1
		exec tmux attach-session -t main
	fi
fi

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ==== prompt ====
#
# setopt PROMPT_SUBST
#
# # ---- colors (zsh-native) ----
# RESET="%f%k"
#
# DIR="%F{white}%K{black}"
# END_DIR="%f%k"
#
# GIT="%F{blue}%K{black}"
# END_GIT="%f%k"
#
# GIT_ADD="%F{green}"
# GIT_MOD="%F{yellow}"
# GIT_DEL="%F{red}"
# END_GIT_STATUS="%f"
#
# PY_ENV="%F{black}%K{green}"
# END_PY="%f%k"
#
# # ---- symbols ----
# GIT_ADD_SYM=" "
# GIT_MOD_SYM=" "
# GIT_DEL_SYM=" "
#
# SYMBOL_OK=""
# SYMBOL_ERR="󰯈"
#
# # ---- helpers ----
#
# short_pwd() {
# 	local pwd="${PWD/#$HOME/~}"
# 	local IFS='/'
# 	local -a parts
# 	read -rA parts <<< "$pwd"
#
# 	local out=""
# 	local last_i=$(( ${#parts[@]} - 1 ))
#
# 		for i in {1..${#parts[@]}}; do
# 			local idx=$(( i - 1 ))
# 			if (( idx == 0 || idx == last_i )); then
# 				out+="/${parts[idx]}"
# 			else
# 				out+="/${parts[idx]:0:2}"
# 			fi
# 		done
#
# 		print "${out#/}"
# 	}
#
# git_branch() {
# 	command git rev-parse --abbrev-ref HEAD 2>/dev/null
# }
#
# git_status_counts() {
# 	command git rev-parse --is-inside-work-tree &>/dev/null || return
#
# 	local status
# 	status=$(git status --porcelain 2>/dev/null) || return
# 	[[ -z "$status" ]] && return
#
# 	local added modified deleted
#
# 	added=$(print "$status" | grep -E '^(A|M ).' | wc -l | tr -d ' ')
# 	modified=$(print "$status" | grep -E '^( M|MM|AM| T)' | wc -l | tr -d ' ')
# 	deleted=$(print "$status" | grep -E '^( D|D )' | wc -l | tr -d ' ')
#
# 	local out=""
# 	(( added > 0 ))    && out+=" ${GIT_ADD}${GIT_ADD_SYM}${added}${END_GIT_STATUS}"
# 	(( modified > 0 )) && out+=" ${GIT_MOD}${GIT_MOD_SYM}${modified}${END_GIT_STATUS}"
# 	(( deleted > 0 ))  && out+=" ${GIT_DEL}${GIT_DEL_SYM}${deleted}${END_GIT_STATUS}"
#
# 	print "$out"
# }
#
# python_venv() {
# 	[[ -n "$VIRTUAL_ENV" ]] && print "${VIRTUAL_ENV:t}"
# }
#
# # ---- prompt builder ----
#
# custom_prompt() {
# 	local exit_code=$?
# 	local symbol="$SYMBOL_OK"
# 	(( exit_code != 0 )) && symbol="$SYMBOL_ERR"
#
# 	# dir
# 	local dir_box="${END_DIR}${DIR}$(short_pwd)${END_DIR}"
#
# 	# git
# 	local git_box=""
# 	local git=$(git_branch)
# 	if [[ -n "$git" ]]; then
# 		local git_status=$(git_status_counts)
# 		git_box=" │ ${GIT} $git${git_status} ${END_GIT}"
# 	fi
#
# 	# python
# 	local py_box=""
# 	local py=$(python_venv)
# 	[[ -n "$py" ]] && py_box=" ${END_PY}${PY_ENV}  $py ${END_PY}"
#
# 	PROMPT=$'\n'"${dir_box}${git_box}${py_box} ${symbol} "
# }
#
# # ---- hook (zsh replacement for PROMPT_COMMAND) ----
#
# autoload -Uz add-zsh-hook
# add-zsh-hook precmd custom_prompt
