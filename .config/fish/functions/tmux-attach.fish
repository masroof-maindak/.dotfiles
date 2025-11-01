function tmux-attach
    if test (count $argv) -ge 2
        echo "tmux-attach: Expected exactly one argument (session name)." >&2
        return 1
    end

    set -l session $argv[1]

    if test -z $session
        tmux attach-session || tmux-new
    else
        tmux attach-session -t $session || tmux-new $session
    end
end
