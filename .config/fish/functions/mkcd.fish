function mkcd
    if test (count $argv) -ne 1
        echo "mkcd: Expected exactly one argument (the directory name)." >&2
        return 1
    end
    mkdir -p -- $argv[1] && cd $argv[1]
end
