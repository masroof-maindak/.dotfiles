# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Prompt
PS1="\w; "
# PS1="\033[0;33m\u \033[2m\w \033[0m\nΣ "

# Unlimited history
HISTSIZE=-1
HISTFILESIZE=-1

# Source aliases
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

# Functions
lfcd () {
    cd "$(command lf -print-last-dir "$@")"
}

mkcd () {
    mkdir -p -- "$1" && cd -P -- "$1"
}

serve () {
	if [ $# -ne 1 ]; then
		echo "Usage: serve <port_number>"
		return
	fi
    python -m http.server "$1"
}
