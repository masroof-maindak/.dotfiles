# Usage
# Ctrl+T -> Paste selected files/directories onto command line

# bat can't detect the theme when piped into fzf. Locally, darkman sets the
# universal $BAT_THEME (see darkman/bat.sh); elsewhere (remote machines),
# `swamp-mode` asks the terminal once, at shell startup.

set -g _fzf_preview_cmd
if command -q bat
    if set -q BAT_THEME; or not command -q swamp-mode
        set _fzf_preview_cmd 'bat -P -p --color=always {} --line-range=:250'
    else
        set _fzf_preview_cmd "bat --theme=swamp-$(swamp-mode) -P -p --color=always {} --line-range=:250"
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

