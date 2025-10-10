function lfcd --wraps="lf" --description="lf - Terminal file manager (changing directory on exit)"
    # `command` is needed in case `lfcd` is aliased to `lf`.
    # Quotes will cause `cd` to not change directory if `lf` prints nothing to stdout due to an error.
    cd "$(command lf -print-last-dir $argv)"
end

function mkcd
    mkdir -p -- $argv[1] && cd -P -- $argv[1]
end

function plans
    rg 'TODO|NOTE|FIXME|HACK|CHECK' && echo
end

function trnt
    transmission-daemon -t -u a -v b -p 9091 -a "127.0.0.1"
end
