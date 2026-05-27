if status is-interactive

    set -U EDITOR bob use nightly

    function license
        bass source ~/dotfiles/scripts/init_license.sh
    end

    function fp
        bass source ~/dotfiles/scripts/file_pickers.sh $argv
    end

    function s
        fp s
    end

    function ss
        fp ss
    end

    function g
        fp g
    end

    function jump
        fp jump
    end

    function sfish
        source ~/.config/fish/config.fish
    end

    function fish_prompt
        set -l last_status $status
        set -l stat
        if test $last_status -ne 0
            set stat (set_color red)" $last_status "(set_color --reset)
        end
        string join '' -- (prompt_pwd) (set_color --reset) $stat '$ '
    end
end
