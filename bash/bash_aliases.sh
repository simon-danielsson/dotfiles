# website management ----------------------------------------------------------

alias blog="~/dev/rust/website_2027/tools/blog.sh"

publish() {
    cd "~/dev/rust/website_2027"
    git add --all
    git commit -m "new blog post"
    git push
}

# external programs -----------------------------------------------------------

alias ai="ollama run default"

# mupdf with invert as def (macOS = mupdf-gl, linux = mupdf)
mupdf() {
    if command -v mupdf-gl >/dev/null 2>&1; then
        command mupdf-gl -I "$@"
    elif command -v mupdf >/dev/null 2>&1; then
        command mupdf -I "$@"
    else
        echo "mupdf not found" >&2
        return 1
    fi
}

# terminal cheat lookup
cheat() {
    curl cheat.sh/$@
}

# shorten url
short() {
    curl -F url=$@ https://shorta.link
}

# define word
define() {
    curl dict.org/d:$@
}

# get size of current dir
size() {
    dir_size=$(du -sh . | awk '{print $1}')
    echo "Current directory size: $dir_size"
}

# vim config
alias vimconf="cd ~/dotfiles/nvim/.config/nvim"

# vim pack
alias vimpack="cd ~/.local/share/nvim/site/pack/core/opt"

# touch init LICENSE file
alias license="~/dotfiles/scripts/init_license.sh"

# cenv c project generator and build-system -----------------------------------

run() {
    local dir="$(pwd)"

    while [[ "$dir" != "$HOME" ]]; do
        if [[ -f "$dir/run.py" ]]; then
            (cd "$dir" && ./run.py "$@")
            return
        fi
        dir="$(dirname "$dir")"
    done

    echo "no project root found" >&2
    return 1
}

cinitraw() {
    cp $HOME/dev/python/c_template/init.py .
    chmod +x init.py
    cp -R $HOME/dev/python/c_template/cinit_temp .
    ./init.py $1 "$2"
    command rm init.py
    command rm -rf cinit_temp

}

cinit() {
    file="init.py"
    curl -O https://raw.githubusercontent.com/simon-danielsson/c_template/refs/heads/main/"$file" || {
        echo "failed to curl $file" >&2
        exit 1
    }
    curl -L https://github.com/simon-danielsson/c_template/archive/refs/heads/main.tar.gz \
    | tar -xz --strip-components=1 c_template-main/cinit_temp
    chmod +x ./"$file"
    ./"$file" $1 "$2"
    command rm "$file"
    command rm -rf cinit_temp
}

# neovim via bob
NVIM="bob run nightly"
alias nvim=$NVIM
alias nv=$NVIM
alias vnim=$NVIM
alias nivm=$NVIM

# add to clipboard
alias clip="pbcopy"

# source .bashrc
SBASH="source ~/.bashrc"
alias sbash=$SBASH
alias sb=$SBASH
alias sba=$SBASH

# safe mv command
alias mv="mv -i"

# i can't type "exit" properly
alias exti="exit"
alias t="exit"
alias e="exit"
alias xeti="exit"
alias ex="exit"
alias eixt="exit"
alias exi="exit"
alias xti="exit"

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

# recursively delete all trash files in current folder
unalias ds 2>/dev/null
ds() {
    find . \
        \( \
            -name ".DS_Store" \
            -o -name "Thumbs.db" \
            -o -name "nvim.log" \
            -o -name "*.tmp" \
            -o -name ".pytest_cache" \
            -o -name "__pycache__" \
        \) \
        -delete
}

alias ff="clear && fastfetch --config neofetch"
alias of="clear && COLORTERM= onefetch -d url churn --no-title --no-art --no-color-palette --nerd-fonts"

# ls default
alias ta='exa -a --icons -I ".DS_Store|.git|.gitignore"'
alias ls='exa -al --git --sort modified'

# safe rm command
rm() {
  local cwd
  cwd="$(pwd -P)"

  if [[ "$cwd" == "/" || "$cwd" == "$HOME" ]]; then
    echo "'rm' blocked: inside home dir"
    echo "use command 'permanent' instead"
    return 1
  fi

  trash "$@"
}

# safe rm command override
permanent() {
  echo "delete permanently: $*"
  read -p "type DELETE to continue: " confirm
  [[ "$confirm" != "DELETE" ]] && return 1

  /bin/rm "$@"
}

# fzf pickers -----------------------------------------------------------------

# emoji picker
EM_PICKER="/Users/simondanielsson/dotfiles/scripts/emoji-picker.sh"
alias emoji=$EM_PICKER
alias em=$EM_PICKER

# devicon picker
DEV_PICKER="/Users/simondanielsson/dotfiles/scripts/devicon-picker.sh"
alias devicon=$DEV_PICKER
alias dev=$DEV_PICKER

