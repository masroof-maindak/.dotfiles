function d2ti --description="Dir 2 Txt Interactive; fzf + wl-copy"
    d2t -- $(fzf --preview 'bat --theme="swamp-$(darkman get)" -P -p --color=always {} --line-range=:250') | wl-copy
end
