# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# -- History --
HISTSIZE=2048
HISTFILE="$XDG_CACHE_HOME/bash/history"
HISTFILESIZE=8192
HISTCONTROL=ignoreboth:erasedups

shopt -s histappend
shopt -s autocd

#  -- Source aliases --
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

# -- Functions --
lfcd() { cd "$(command lf -print-last-dir "$@")"; }
mkcd() { mkdir -p -- "$1" && cd -P -- "$1"; }
plans() { rg 'TODO|NOTE|FIXME|HACK|CHECK' && echo; }
trnt() { transmission-daemon -t -u a -v b -p 9091 -a "127.0.0.1"; }
osc7_cwd() {
    # Ctrl + Shift + N opens new terminal at PWD
    local strlen=${#PWD}
    local encoded=""
    local pos c o
    for ((pos = 0; pos < strlen; pos++)); do
        c=${PWD:$pos:1}
        case "$c" in
        [-/:_.!\'\(\)~[:alnum:]]) o="${c}" ;;
        *) printf -v o '%%%02X' "'${c}" ;;
        esac
        encoded+="${o}"
    done
    printf '\e]7;file://%s%s\e\\' "${HOSTNAME}" "${encoded}"
}

# -- Prompt --
# https://gist.github.com/hacst/4538282
e() { echo -n "\033[$@m"; }
f() { e "3$1"; }

red="$(f 1)"
green="$(f 2)"
yellow="$(f 3)"
blue="$(f 4)"
pink="$(f 5)"
cyan="$(f 6)"

reset="$(e 0)"
bold="$(e 1)"
invert="$(e 7)"

branch_info() {
    echo -n "\[$bold\]"
    if [[ $(git diff --shortstat 2>/dev/null | tail -n1) != "" ]]; then
        echo -n "\[$invert\]*"
    fi
}

git_branch() {
    local branch=$(git branch --show-current 2>/dev/null)
    [ -n "$branch" ] && echo -n " $(branch_info)(${branch})\[$reset\]"
}

prompt() {
    PS1="\[$yellow\]${USER}\[$cyan\]$(git_branch) \[$blue\]\w \[$reset\]$ "
}

PROMPT_COMMAND=prompt
PROMPT_COMMAND=${PROMPT_COMMAND:+${PROMPT_COMMAND%;}; }osc7_cwd

eval "$(zoxide init bash)"
