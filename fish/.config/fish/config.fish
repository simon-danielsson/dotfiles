if status is-interactive

    # general -----------------------------------------------------------------
    set -U fish_greeting

    alias ff="clear && fastfetch --config neofetch"
    alias of="clear && COLORTERM= onefetch -d url churn --no-title --no-art \
        --no-color-palette && todo"

    alias exti="exit"
    alias t="exit"
    alias e="exit"
    alias xeti="exit"
    alias ex="exit"
    alias eixt="exit"
    alias exi="exit"
    alias xti="exit"

    alias todo='~/dev/python/todo.py/src/todo.py'

    function cheat
        curl "cheat.sh/$argv"
    end

    alias run='./run.py'
    alias license='bass source ~/dotfiles/scripts/init_license.sh'

    # file pickers ------------------------------------------------------------

    function fp
        bass ~/dotfiles/scripts/file_pickers.sh $argv
    end
    alias s='fp s'
    alias ss='fp ss'
    alias g='fp g'
    alias jump='fp jump'

    alias sfish='source ~/.config/fish/config.fish'

    # prompt ------------------------------------------------------------------

    function fish_prompt
        set -l last_status $status
        set -l stat
        if test $last_status -ne 0
            set stat (set_color red)" $last_status "(set_color --reset)
        end
        string join '' -- (set_color --reset) (prompt_pwd) (set_color --reset) $stat '$ '
    end
end
