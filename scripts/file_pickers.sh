#!/usr/bin/env bash

# grep
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
    return 0
}

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
    return 0
}

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
    return 0
}

jump() {
    local entries=(
        $'downloads\t'"$HOME/Downloads"
        $'desktop\t'"$HOME/Desktop"
        $'dotfiles\t'"$HOME/dotfiles"
        $'config\t'"$HOME/.config"
        $'notes\t'"$HOME/notes"
        $'socker\t'"$HOME/dev/socker"
        $'nvim config\t'"$HOME/dotfiles/nvim/.config/nvim"
        $'website\t'"$HOME/dev/rust/website_2027"
        $'development\t'"$HOME/dev"
        $'emacs config\t'"$HOME/dotfiles/emacs"
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

"$@"
