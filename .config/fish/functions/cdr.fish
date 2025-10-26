function cdr --description="cd back to the root folder of the current repository"
    set -l dir (git rev-parse --show-toplevel)
    test $dir && cd $dir
end
