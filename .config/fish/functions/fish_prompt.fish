set -g fish_prompt_pwd_dir_length 0
set -g fish_transient_prompt 1

function fish_prompt
    set -l prompt_content

    if contains -- --final-rendering $argv
        # Transient
        set prompt_content (set_color blue)(basename (prompt_pwd))
    else
        # Final
        set prompt_content (set_color blue)(prompt_pwd)
        set -l branch (fish_git_branch)
        set prompt_content "$prompt_content"(set_color cyan --bold)"$branch"
    end

    set -l out "$prompt_content"(set_color normal)" \$ "
    echo -n "$out"
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

function fish_git_branch
    set -l branch (git branch --show-current 2>/dev/null)
    if test -n "$branch"
        echo -n " "
        set -l git_status_output (git diff --shortstat 2>/dev/null | tail -n1)
        if test -n "$git_status_output"
            echo -n (set_color --reverse)"*"
        end
        echo -n "("$branch")"
    end
end
