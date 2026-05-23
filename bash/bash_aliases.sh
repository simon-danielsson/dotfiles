# website management ----------------------------------------------------------

# create new blog post
alias blog="~/dotfiles/scripts/create-new-blog-entry-for-website.sh"

# cd to blog dir
alias blogdir="cd ~/dev/rust/website/src/blog/blog_entries/"

# cd website repo
alias website="cd ~/dev/rust/website/"

# external programs -----------------------------------------------------------

# open devdocs.io in browser (MacOS/linux)
devdocs() {
    local url="https://devdocs.io"
    local min="open -a \"Min\" $@ >/dev/null 2>&1 &"
    if command -v min >/dev/null 2>&1; then
        min "$url"
    elif command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$url" >/dev/null 2>&1 &
    elif command -v open >/dev/null 2>&1; then
        open "$url" >/dev/null 2>&1 &
    else
        echo "No supported browser found."
        return 1
    fi
}

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
alias license="~/dotfiles/scripts/init-license.sh"

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

# ls default
alias ls='ls -paGAoh -D "%Y-%m-%d %H:%M" '

# my own worse version of ls
alias ta="ta -a "

# safe rm command
rm() {
  local cwd
  cwd="$(pwd -P)"

  if [[ "$cwd" == "/" || "$cwd" == "$HOME" ]]; then
    echo "'rm' command blocked: refusing to run rm from home dir"
    echo "Use command 'permanent' if you really mean it."
    return 1
  fi

  trash "$@"
}

# safe rm command override
permanent() {
  echo "Permanent delete (no Trash): $*"
  read -p "Type DELETE to continue: " confirm
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

jump() {
    local entries=(
        $'downloads\t'"$HOME/Downloads"
        $'desktop\t'"$HOME/Desktop"
        $'dotfiles\t'"$HOME/dotfiles"
        $'notes\t'"$HOME/notes"
        $'nvim config\t'"$HOME/dotfiles/nvim/.config/nvim"
        $'development\t'"$HOME/dev"
      )

  local selected label target

  selected="$(
    printf '%s\n' "${entries[@]}" \
      | fzf --prompt=" " \
            --height=40% \
            --reverse \
            --border \
            --delimiter=$'\t' \
            --with-nth=1
  )" || return

  label="${selected%%$'\t'*}"
  target="${selected#*$'\t'}"

  # expand ~
  eval "target=\"$target\""

  if [[ -d "$target" ]]; then
    cd "$target" || return
  elif [[ -f "$target" ]]; then
    nvim "$target"
  else
    printf 'Not found: %s\n' "$target" >&2
    return 1
  fi
}

# grep
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
        case "$target" in
            *.pdf)
                mupdf "$target" & disown
                ;;
            *)
                nvim "$target"
                ;;
        esac
    fi

}

# global search from '/' directory
unalias ss 2>/dev/null
ss() {
    local target
    target=$(fd --type f --type d --hidden . ~ | \
        fzf --preview='[[ -d {} ]] && exa -al {} || bat --style=numbers {}') || return
    if [[ -d $target ]]; then
        cd "$target"
    elif [[ -f $target ]]; then
        case "$target" in
            *.pdf)
                mupdf "$target" & disown
                ;;
            *)
                nvim "$target"
                ;;
        esac
    fi
}
