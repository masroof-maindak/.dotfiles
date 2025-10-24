fzf --fish | source

# Usage
# Ctrl+T -> Paste selected files/directories onto command line

# Preview file w/ bat
set -x FZF_CTRL_T_OPTS "
    --walker-skip .git,node_modules,target,.venv
    --preview 'bat -P -p --color=always {}'
    --bind 'ctrl-/:change-preview-window(down|hidden)'
    --height=100%
"
# Disable Alt+C to CD fuzzily; already have zoxide and LF's Ctrl+F
set -x FZF_ALT_C_COMMAND ""

# Disable Ctrl+R to fzf history; the line numbers in the UI are annoying and
# the default is honestly pretty good
set -x FZF_CTRL_R_COMMAND ""


