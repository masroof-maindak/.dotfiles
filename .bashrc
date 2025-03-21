# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# -- History --
HISTSIZE=2048
HISTFILE="$HOME/.cache/bash/history"
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

r="$(f 1)"
g="$(f 2)"
y="$(f 3)"
b="$(f 4)"
p="$(f 5)"
c="$(f 6)"

reset="$(e 0)"
inv="$(e 7)"
bold="$(e 1)"

branch_info() {
	echo -n "\[$bold\]"
	if [[ $(git diff --shortstat 2>/dev/null | tail -n1) != "" ]]; then
		echo -n "\[$inv\]*"
	fi
}

git_branch() {
	local branch=$(git branch --show-current 2>/dev/null)
	[ -n "$branch" ] && echo -n " $(branch_info)($branch)\[$reset\]"
}

prompt() {
	PS1="\[$y\]\$(date +%H:%M:%S)\[$g\]$(git_branch) \[$b\]\w \[$reset\]\$ "
}

PROMPT_COMMAND=prompt
PROMPT_COMMAND=${PROMPT_COMMAND:+${PROMPT_COMMAND%;}; }osc7_cwd
