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

    function cheat
        curl "cheat.sh/$argv"
    end

    alias license='~/dotfiles/scripts/init_license.sh'

    alias ff="clear && fastfetch --config neofetch"

    alias of="clear && COLORTERM= onefetch -d churn --disabled-fields created \
        size authors --no-title --no-art --no-color-palette && \
        echo '' && ta"

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
