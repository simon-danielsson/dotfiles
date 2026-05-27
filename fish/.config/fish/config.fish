if status is-interactive

    set -U fish_greeting

    alias ff="clear && fastfetch --config neofetch"
    alias of="clear && COLORTERM= onefetch -d churn --no-title --no-art \
        --no-color-palette && todo"

    alias ex="exit" # shadow ex command that I hit by mistake all the time

    alias todo='~/dev/python/todo.py/src/todo.py'

    function cheat
        curl "cheat.sh/$argv"
    end

    alias run='./run.py'
    alias license='bass source ~/dotfiles/scripts/init_license.sh'

    alias f='fzf --reverse --algo=v1 \
        +m --cycle --no-scrollbar \
        --border --preview "bat {}"'

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
        string join '' -- (set_color --reset) (prompt_pwd) \
            (set_color --reset) $stat '$ '
    end
end
