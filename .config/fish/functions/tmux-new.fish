function tmux-new
    if test (count $argv) -ge 2
        echo "tmux-new: Expected exactly one argument (session name)." >&2
        return 1
    end

    set -l session $argv[1]

    if test -z "$session"
        # Select random name
        set -l rand (printf "%06x" (math (random) % 0x1000000))
        tmux-new tmp-$rand
    else
        # Create detached session
        tmux new-session -d -s $session

        # Attach to session, switching to it creation fails (already existed)
        tmux attach-session -t $session || tmux switch-client -t $session
    end
end
