function tmux-del
    set -l session (tmux list-sessions | fzf | cut -d: -f1)

    if test "$session"
        tmux kill-session -t $session
    end
end
