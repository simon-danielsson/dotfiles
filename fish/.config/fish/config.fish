if status is-interactive

    set -Ux EDITOR "nvim"

    alias term="NVIM_MODE=term nvim"

    alias _cinit="bass ~/dotfiles/scripts/cinit.sh $argv"
    alias cinit="_cinit cinit"
    alias run="_cinit run"

    set -U fish_greeting

    alias visa="~/dev/c/visa/build/release/*"

    alias ta='exa -a --icons -I ".DS_Store|.git|.gitignore"'
    alias ls='exa -al --git --sort modified'
    function cd
        builtin cd $argv
    end

    alias ex="exit"
    alias exti="exit"
    alias eixt="exit"
    alias ext="exit"
    alias exi="exit"
    alias xti="exit"

    alias rg="command rg -U -N $argv"

    function g
        set query $argv

        set rg_opts \
            --column \
            --line-number \
            --no-heading \
            --color=never \
            --smart-case \
            --hidden \
            --glob '!.git/' \
            --glob '!target/' \
            --glob '!node_modules/' \
            --glob '!.gitignore' \
            --glob '!*.lock'

        set rg_cmd "rg $rg_opts . 2>/dev/null || true"

        fzf \
            --disabled \
            --query "$query" \
            --delimiter : \
            --preview 'bat --style=numbers --highlight-line {2} {1}' \
            --preview-window '~3,+{2}/2' \
            --bind "start:reload:$rg_cmd" \
            --bind "change:reload:$rg_cmd" \
            --bind 'enter:become(nvim "+call cursor({2},{3})" -- {1})'
    end

    function cheat
        curl "cheat.sh/$argv"
    end

    alias license='~/dotfiles/scripts/init_license.sh'

    alias ff="clear && fastfetch --config neofetch"

    alias of="clear && COLORTERM= onefetch -d churn --disabled-fields created \
        size authors --no-title --no-art --no-color-palette && \
        echo '' && ta"

    function s
        set dir (bash -c '
        cd() { builtin cd "$1" && pwd; }
        source ~/dotfiles/scripts/file_pickers.sh
        s
        ')
        test -n "$dir"; and cd "$dir"
    end

    function ss
        set dir (bash -c '
        cd() { builtin cd "$1" && pwd; }
        source ~/dotfiles/scripts/file_pickers.sh
        ss
        ')
        test -n "$dir"; and cd "$dir"
    end

    function jump
        set dir (bash -c '
        cd() { builtin cd "$1" && pwd; }
        source ~/dotfiles/scripts/file_pickers.sh
        jump
        ')
        test -n "$dir"; and cd "$dir"
    end

    alias sfish='source ~/.config/fish/config.fish'

    # prompt ------------------------------------------------------------------

    function fish_right_prompt -d "right prompt"
        string join ''
    end

    function fish_prompt
        set -l last_status $status
        set -l stat
        if test $last_status -ne 0
            set stat (set_color red)" $last_status "(set_color --reset)
        end
        string join '' -- \n (set_color --reset) (prompt_pwd) \
            (set_color --reset) $stat '$ '
    end
end
