#!/usr/bin/env bash

# ==== vars ====

# Foreground colors
FG_DARK1="\[\e[38;5;235m\]"   # #25252d
FG_DARK2="\[\e[38;5;238m\]"   # #40404f
FG_WHITE="\[\e[38;5;15m\]"    # #ffffff

RESET="\[\e[0m\]"

DIR=${FG_WHITE}

GIT=${FG_WHITE}

# python env
PY_ENV="\[\e[38;5;11m\]"

# Success/error symbols
SYMBOL_OK="\[\e[38;5;15m\]${RESET}"
SYMBOL_ERR="\[\e[38;5;15m\]󰯈${RESET}"

# git symbols
GIT_ADD_SYM=" "
GIT_MOD_SYM=" "
GIT_DEL_SYM=" "

# ==== helpers ====

short_pwd() {
	local pwd="${PWD/#$HOME/\~}"

	local leading=""
	if [[ "$pwd" == /* ]]; then
		leading="/"
		pwd="${pwd#/}"
	fi

	IFS='/' read -ra parts <<< "$pwd"
	local n=${#parts[@]}
	local out="$leading"

	if (( n <= 3 )); then
		out+=$(IFS=/; echo "${parts[*]}")
	else
		local start=$(( n - 3 ))
		for (( i=start; i<n; i++ )); do
			out+="/${parts[i]}"
		done
	fi

	echo "$out"
}

git_branch() {
	git rev-parse --abbrev-ref HEAD 2>/dev/null
}

git_status_counts() {
	git rev-parse --is-inside-work-tree &>/dev/null || return

	local status
	status=$(git status --porcelain 2>/dev/null)
	[[ -z "$status" ]] && return

	local added modified deleted
	added=$(( $(echo "$status" | grep -E '^(A|M ).' | wc -l) ))
	modified=$(( $(echo "$status" | grep -E '^( M|MM|AM| T)' | wc -l) ))
	deleted=$(( $(echo "$status" | grep -E '^( D|D )' | wc -l) ))

	local out=""
	(( added > 0 )) && out+="${out:+ }${GIT}${GIT_ADD_SYM}${added}${RESET}"
	(( modified > 0 )) && out+="${out:+ }${GIT}${GIT_MOD_SYM}${modified}${RESET}"
	(( deleted > 0 )) && out+="${out:+ }${GIT}${GIT_DEL_SYM}${deleted}${RESET}"

	echo "$out"
}

python_venv() {
	if [[ -n "$VIRTUAL_ENV" ]]; then
		echo "$(basename "$VIRTUAL_ENV")"
	fi
}

battery_status() {
	if command -v upower >/dev/null; then
		local battery
		battery=$(upower -i "$(upower -e | grep BAT | head -n1)" 2>/dev/null)
		local percent
		percent=$(echo "$battery" | awk '/percentage:/ {print $2}')
		echo "$percent"
	fi
}

# ==== prompt build ====

custom_prompt() {
	local exit_code=$?
	local symbol="${SYMBOL_OK}"
	[[ $exit_code -ne 0 ]] && symbol="${SYMBOL_ERR}"

	# dir
	local dir_box="${DIR}$(short_pwd)${RESET}"

	# git
	local git
	git=$(git_branch)
	local git_box=""
	if [[ -n "$git" ]]; then
		local git_status
		git_status=$(git_status_counts)
		git_box=" ${GIT} $git${RESET}"
		[[ -n "$git_status" ]] && git_box+=" ${git_status}"
		git_box+="${RESET}"
	fi

	# python env
	local py
	py=$(python_venv)
	local py_box=""
	[[ -n "$py" ]] && py_box=" ${PY_ENV} $py${RESET}"

	PS1="\n${dir_box}${git_box}${py_box}\n${symbol} "
}

# ==== export PS1 ====

PROMPT_COMMAND=custom_prompt
