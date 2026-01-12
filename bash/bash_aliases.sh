# ==== general ====

# kill all nvim and tmux processes, and exit ghostty
alias q="~/dotfiles/scripts/kill-nvim-and-tmux.sh"

# add to clipboard
alias clip="pbcopy"

# nvim nightly
alias nvim="bob run nightly"

# emoji picker
alias emoji="/Users/simondanielsson/dotfiles/scripts/emoji-picker.sh"

# devicon picker
alias devicon="/Users/simondanielsson/dotfiles/scripts/devicon-picker.sh"

# source .bashrc
alias sbash="source ~/.bashrc"

# neofetch
alias nf="clear && neofetch"

# ==== journal ====

journal() {
	local today=$(date +"%Y-%m-%d")
	local dir="$HOME/journal"
	local file="$dir/${today}.typ"
	local template="$dir/template.typ"
	mkdir -p "$dir"
	# Only copy template if the file doesn't already exist
	if [ ! -f "$file" ]; then
		if [ -f "$template" ]; then
			cp "$template" "$file"
		else
			touch "$file"
		fi
	fi
	nvim "$file"
}

# ==== notes ====

alias notes="cd ~/notes"

n() {
	local name="$*"
	local today
	today=$(date +"%Y-%m-%d")
	local dir="$HOME/notes"
	# If no name given, default to "note"
	if [ -z "$name" ]; then
		name="note"
	fi
	# Trim whitespace, replace multiple spaces with a single '-', strip trailing '-',
	# and convert to lowercase
	name=$(echo "$name" | xargs | tr -s ' ' '-' | sed 's/-$//' | tr '[:upper:]' '[:lower:]')
	local file="$dir/${name}_${today}.md"
	mkdir -p "$dir"
	# Create empty file if it doesn't exist
	[ -f "$file" ] || touch "$file"
	nvim "$file"
}

# ==== directories and search ====

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
