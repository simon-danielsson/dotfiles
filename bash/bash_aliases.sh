# === website management ===

# create new blog post
alias blog="~/dotfiles/scripts/create-new-blog-entry-for-website.sh"

# cd to blog dir
alias blogdir="cd ~/dev/rust/website/src/blog/blog_entries/"

# cd website repo
alias website="cd ~/dev/rust/website/"

# === brakoll issue tracker ===

# short
alias b="brakoll"

unalias commit 2>/dev/null
commit() {
    local id="$1"
    brakoll cp $id
    brakoll close $id

    if command -v pbpaste >/dev/null; then
    clip=$(pbpaste)
    elif command -v xclip >/dev/null; then
        clip=$(xclip -o -selection clipboard)
    elif command -v wl-paste >/dev/null; then
        clip=$(wl-paste)
    fi

    git add --all
    git commit -a -m "$clip"
}

# === dev ===

# kill all nvim and tmux processes, and exit ghostty
alias q="~/dotfiles/scripts/kill-nvim-and-tmux.sh"

# safe mv command
alias mv="mv -i"

# neovim
NVIM="bob run nightly"
alias nvim=$NVIM
alias code=$NVIM
alias v=$NVIM
alias nv=$NVIM
alias nvi=$NVIM
alias vim=$NVIM
alias nivm=$NVIM
alias vnim=$NVIM
alias nim=$NVIM

# === general ===

# cmatrix screensaver
alias matrix="cmatrix -u 9 -C white -s"

# invert pdf
alias invpdf="~/dotfiles/scripts/invert-pdf.sh"

# get size of current dir
size() {
dir_size=$(du -sh . | awk '{print $1}')
echo "Current directory size: $dir_size"
}

# add to clipboard
alias clip="pbcopy"

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

# grep using fzf
unalias g 2>/dev/null
g() {
    local query="${*:-}"

    local -a rg_opts=(
        --column
        --line-number
        --no-heading
        --color=never
        --smart-case
        --hidden
        --glob '!.git/'
        --glob '!target/'
        --glob '!node_modules/'
        --glob '!.gitignore'
        --glob '!*.lock'
    )

    local reload_cmd
    reload_cmd="rg $(printf "%q " "${rg_opts[@]}") {q} . 2>/dev/null || true"

    fzf --disabled \
        --query "$query" \
        --delimiter : \
        --preview 'bat --style=numbers --highlight-line {2} {1}' \
        --preview-window '~3,+{2}/2' \
        --bind "start:reload:$reload_cmd" \
        --bind "change:reload:$reload_cmd" \
        --bind 'enter:become(nvim "+call cursor({2},{3})" -- {1})'
}

# local search from current directory
unalias s 2>/dev/null
s() {
        local target
        target=$(fd --type f --type d --hidden | fzf --preview='[[ -d {} ]] && exa -al {} || bat --style=numbers {}') || return
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
        target=$(fd --type f --type d --hidden . ~ | fzf --preview='[[ -d {} ]] && exa -al {} || bat --style=numbers {}') || return
        if [[ -d $target ]]; then
                cd "$target"
        elif [[ -f $target ]]; then
                nvim "$target"
        fi
}
