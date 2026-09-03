# _fzf
#
# Fzf wrapper that sets the right preview command from a single source (the
# `_fzf_preview_cmd` global variable `fzf.fish`). The preview command in
# question can't be made the default, because in numerous places, we want to
# use `fzf` without a previewer.

function _fzf
    if not contains -- --no-preview $argv
        fzf --preview="$_fzf_preview_cmd" $argv
    else
        fzf $argv
    end
end
