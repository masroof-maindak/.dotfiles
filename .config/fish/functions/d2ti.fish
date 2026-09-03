function d2ti --description="Dir 2 Txt Interactive; fzf + wl-copy"
    set -l items (_fzf)
    d2t -- $items | wl-copy
end
