function d2ti --description="Dir 2 Txt Interactive; fzf + wl-copy"
    d2t $(fzf) | wl-copy
end
