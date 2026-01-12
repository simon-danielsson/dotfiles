#!/usr/bin/env bash

# Foreground colors
FG_DARK1="\[\e[38;5;234m\]"   # #222222
FG_DARK2="\[\e[38;5;236m\]"   # #333333
FG_WHITE="\[\e[38;5;15m\]"    # #ffffff

# Background colors
BG_DARK1="\[\e[48;5;234m\]"   # #222222
BG_DARK2="\[\e[48;5;236m\]"   # #333333
BG_WHITE="\[\e[48;5;15m\]"    # #ffffff

# ==== colours ====

RESET="\[\e[0m\]"

# dir
DIR="\[\e[38;5;15;48;5;236m\]"
END_DIR="\[\e[38;5;236m\]"

# git branch
GIT="\[\e[34;5;15;48;5;236m\]"
END_DIR="\[\e[38;5;236m\]"
END_GIT="\[\e[38;5;236m\]"

GIT_ADD="\[\e[32;5;15;48;5;236m\]"
GIT_MOD="\[\e[33;5;15;48;5;236m\]"
GIT_DEL="\[\e[31;5;15;48;5;236m\]"
END_GIT_STATUS="\[\e[38;5;236m\]"

# git symbols
GIT_ADD_SYM=" "
GIT_MOD_SYM=" "
GIT_DEL_SYM=" "

# python env
PY_ENV="\[\e[38;5;11;48;5;236m\]"
END_PY="\[\e[38;5;236m\]"

# Success/error symbols
SYMBOL_OK=""
SYMBOL_ERR="󰯈"

# ==== helpers ====

short_pwd() {
	local pwd="${PWD/#$HOME/\~}"

	# Remove leading / for splitting, but remember if it started with /
	local leading=""
	if [[ "$pwd" == /* ]]; then
		leading="/"
		pwd="${pwd#/}"
	fi

	IFS='/' read -ra parts <<< "$pwd"
	local n=${#parts[@]}
		local out="$leading"

		if (( n <= 3 )); then
			# Short path: show everything
			out+=$(IFS=/; echo "${parts[*]}")
		else
			# Long path: show only last two parent folders + current
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
	(( added > 0 )) && out+="${out:+ }${GIT_ADD}${GIT_ADD_SYM}${added}${END_GIT_STATUS}"
	(( modified > 0 )) && out+="${out:+ }${GIT_MOD}${GIT_MOD_SYM}${modified}${END_GIT_STATUS}"
	(( deleted > 0 )) && out+="${out:+ }${GIT_DEL}${GIT_DEL_SYM}${deleted}${END_GIT_STATUS}"

	echo " $out"
}

python_venv() {
	if [[ -n "$VIRTUAL_ENV" ]]; then
		echo "$(basename "$VIRTUAL_ENV")"
	fi
}

battery_status() {
	if command -v upower >/dev/null; then
		local battery=$(upower -i $(upower -e | grep BAT) 2>/dev/null)
		local percent=$(echo "$battery" | awk '/percentage:/ {print $2}')
		echo "$percent"
	fi
}

# ==== prompt build ====

custom_prompt() {
	local exit_code=$?
	local symbol="${SYMBOL_OK}"
	[[ $exit_code -ne 0 ]] && symbol="${SYMBOL_ERR}"

	# dir
	local dir_box="${END_DIR}${DIR}$(short_pwd)${RESET}${END_DIR}${RESET}"

	# git
	local git=$(git_branch)
	local git_box=""
	if [[ -n "$git" ]]; then
		local dir_box="${END_DIR}${DIR}$(short_pwd)"
		local git_status
		git_status=$(git_status_counts)

		git_box=" │ ${GIT} $git${git_status} ${RESET}${END_GIT}${RESET}"
	fi

	# python env
	local py=$(python_venv)
	local py_box=""
	[[ -n "$py" ]] && py_box=" ${END_PY}${PY_ENV}  $py ${RESET}${END_PY}${RESET}"

	# assembly
	PS1="\n${dir_box}${git_box}${py_box}${rust_box} ${symbol} "
}

# ==== export PS1 ====

PROMPT_COMMAND=custom_prompt
