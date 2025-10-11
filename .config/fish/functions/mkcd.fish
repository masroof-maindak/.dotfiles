function mkcd
    mkdir -p -- $argv[1] && cd -P -- $argv[1]
end