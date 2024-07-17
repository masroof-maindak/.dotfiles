# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Prompt
PROMPT_COMMAND='PS1X=$(perl -p -e "s|^${HOME}|~|;s|([^/])[^/]*/|$""1/|g" <<<${PWD})'
PROMPT1='\[\e[91;1m\]${PS1X}\[\e[0m\] % '
# ---
parse_git_branch() {
  git branch 2>/dev/null | sed -n '/\* /s///p'
}
PROMPT2="\[\033[01;34m\]\w \[\033[01;33m\]\$(parse_git_branch)\[\033[00m\]% "
export PS1=$PROMPT1

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
    local port=${1:-8081}
    if [[ $port =~ ^[0-9]+$ ]]; then
        python -m http.server "$port"
    else
        echo "Usage: serve [port_number]"
        return 1
    fi
}

chng-prmpt () {
    if [ "$PS1" = "$PROMPT1" ]; then
        export PS1=$PROMPT2
    else
        export PS1=$PROMPT1
    fi
}
