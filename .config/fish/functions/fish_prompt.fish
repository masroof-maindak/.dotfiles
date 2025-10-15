set -g fish_prompt_pwd_dir_length 0
set -g fish_transient_prompt 1

# Reference:
#   https://fishshell.com/docs/current/prompt.html
#   https://fishshell.com/docs/current/cmds/fish_git_prompt.html
set -g __fish_git_prompt_show_informative_status false
set -g __fish_git_prompt_showupstream none
set -g __fish_git_prompt_showdirtystate 1
set -g __fish_git_prompt_showuntrackedfiles 1

function fish_prompt
    set -l prompt_content

    if contains -- --final-rendering $argv
        # Transient
        set prompt_content (set_color blue)(basename (prompt_pwd))
    else
        # Final
        set prompt_content (set_color blue)(prompt_pwd)
        set -l branch (fish_git_prompt)
        set prompt_content "$prompt_content"(set_color cyan --bold)"$branch"
    end

    echo -n "$prompt_content"(set_color normal)" \$ "
end

function fish_right_prompt
    set_color yellow

    if contains -- --final-rendering $argv
        echo -n "."
    else
        echo -n (date "+%H:%M")
    end

    set_color normal
end
