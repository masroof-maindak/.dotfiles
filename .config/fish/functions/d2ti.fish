function d2ti --description="Dir 2 Txt Interactive; fzf + wl-copy"
    d2t -- $(fzf --preview 'bat -P -p --color=always {} --line-range=:250') | wl-copy
end
