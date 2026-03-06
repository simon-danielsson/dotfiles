# === general ===

# cmatrix screensaver
alias matrix="cmatrix -u 9 -C white -s"

# safe mv command
alias mv="mv -i"

# create new blog post
alias blog="~/dotfiles/scripts/create-new-blog-entry-for-website.sh"

# cd website repo
alias website="cd ~/dev/rust/website/"

# kill all nvim and tmux processes, and exit ghostty
alias q="~/dotfiles/scripts/kill-nvim-and-tmux.sh"

# add to clipboard
alias clip="pbcopy"

# neovim
NVIM="bob run nightly"
alias nvim=$NVIM
alias code=$NVIM
alias v=$NVIM
alias nv=$NVIM
alias nvi=$NVIM
alias vim=$NVIM
alias nivm=$NVIM

# emoji picker
EM_PICKER="/Users/simondanielsson/dotfiles/scripts/emoji-picker.sh"
alias emoji=$EM_PICKER
alias em=$EM_PICKER

# devicon picker
DEV_PICKER="/Users/simondanielsson/dotfiles/scripts/devicon-picker.sh"
alias devicon=$DEV_PICKER
alias dev=$DEV_PICKER

# source .bashrc
alias sbash="source ~/.bashrc"

# neofetch (doubles as clear and go back to home dir)
alias nf="cd && clear && neofetch"

# terminal cheat lookup
cheat() {
        curl cheat.sh/$@
}

# shorten url
shorten() {
        curl -F url=$@ https://shorta.link
}

# define word
define() {
        curl dict.org/d:$@
}

# === journal ===

journal() {
        local today=$(date +"%Y-%m-%d")
        local dir="$HOME/journal"
        local file="$dir/${today}.md"
        local template="$dir/template.md"
        mkdir -p "$dir"
        # only copy template if the file doesn't already exist
        if [ ! -f "$file" ]; then
                if [ -f "$template" ]; then
                        cp "$template" "$file"
                else
                        touch "$file"
                fi
        fi
        nvim "$file"
}

# === notes ===

alias notes="cd ~/notes"

n() {
        local name="$*"
        local today
        today=$(date +"%Y-%m-%d")
        local dir="$HOME/notes"
        # if no arg given, default to "note"
        if [ -z "$name" ]; then
                name="note"
        fi
        # format arg
        name=$(echo "$name" | xargs | tr -s ' ' '-' | sed 's/-$//' | tr '[:upper:]' '[:lower:]')
        local file="$dir/${name}_${today}.md"
        mkdir -p "$dir"
        # create empty file if it doesn't exist
        [ -f "$file" ] || touch "$file"
        nvim "$file"
}

# === directories and search ]===

# recursively delete all .DS_Store files in current folder
alias ds='find . -name ".DS_Store" -type f -delete'

# ls default
alias ls='ls -paGAoh -D "%d-%m-%Y %H:%M" '

# my own worse version of ls
alias ta="ta -i -w -a -e"

# local search from current directory
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

# global search from home directory
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
