function tmux-search
    set -l session (tmux list-sessions | fzf | cut -d: -f1)

    if test -z "$TMUX"
        tmux attach-session -t $session
    else
        tmux switch -t $session
    end
end
