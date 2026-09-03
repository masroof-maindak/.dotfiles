# Usage
# Ctrl+T -> Paste selected files/directories onto command line

# If bat & darkman exist (and the latter is running), use darkman to inject the
# right bat theme. This is necessary because bat can't detect the theme by
# itself when its run inside/by fzf or lf, even though it can when run by
# itself.

set -g _fzf_preview_cmd
if command -q bat
    if test -S "$XDG_RUNTIME_DIR/darkman/control.sock"
        set _fzf_preview_cmd 'bat --theme="swamp-$(darkman get)" -P -p --color=always {} --line-range=:250'
    else
        set _fzf_preview_cmd 'bat -P -p --color=always {} --line-range=:250'
    end
else
    set _fzf_preview_cmd 'head {} -n 250'
end

set -x FZF_CTRL_T_OPTS "
    --walker-skip .git,node_modules,target,.venv
    --preview='$_fzf_preview_cmd'
    --bind 'ctrl-/:change-preview-window(down|hidden)'
    --height=100%
"

# Disable Alt+C to CD fuzzily; already have zoxide and LF's Ctrl+F
set -x FZF_ALT_C_COMMAND ""

# Disable Ctrl+R to fzf history; the line numbers in the UI are annoying and
# the default is honestly pretty good
set -x FZF_CTRL_R_COMMAND ""

fzf --fish | source

