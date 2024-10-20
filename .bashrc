# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# History
HISTSIZE=1024
HISTFILE="$HOME/.cache/bash/history"
HISTFILESIZE=4096
HISTCONTROL=ignoreboth:erasedups

# Shell options
shopt -s histappend
shopt -s autocd

# Source aliases
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

# Functions
lfcd() {
	cd "$(command lf -print-last-dir "$@")"
}

mkcd() {
	mkdir -p -- "$1" && cd -P -- "$1"
}

serve() {
	local port=${1:-8081}
	if [[ $port =~ ^[0-9]+$ ]]; then
		python -m http.server "$port"
	else
		echo "Usage: serve <port_number>"
		return 1
	fi
}

# Ctrl + Shift + N opens new terminal at PWD
osc7_cwd() {
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

# Fuzzy Checkout
fzchk() {
	if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		git checkout $(git branch | fzf)
	else
		echo "Not a git repository"
	fi
}

# Open today's journal entry
jrnl() {
	vlt
	local today=$(date +'%m-%d')
	local fpath="03 - Journal/$(date +'%m - %b')/${today}.md"
	if [ -f "$fpath" ]; then
		$EDITOR "$fpath"
	fi
	cd - >/dev/null
}

# Find *.md files in Obsidian vault
fiv() {
	vlt
	local files="$(fd -t f -e md -E '.*' |
		fzf \
			--preview="bat --style=numbers --color=always --line-range=:250 {}" \
			--prompt "Vault: ")"
	if [ -n "$files" ]; then
		echo "$files" | xargs -d "\n" $EDITOR
	fi
	cd - >/dev/null
}

# Print tagged comments
plans() {
	rg TODO && echo
	rg NOTE && echo
	rg FIXME && echo
	rg HACK && echo
	rg CHECK && echo
}

# Prompt
e() {
	printf "\033[$@m"
}

f() {
	e "3$1;6"
}

r="$(e 0)" # reset

g="$(f 2)"
rd="$(f 1)"
b="$(f 4)"
p="$(f 5)"
y="$(f 3)"
c="$(f 6)"

inverse="$(e 7)"
bold="$(e 1)"

# FIXME
git_branch() {
	local branch=$(git branch --show-current 2>/dev/null)
	if [[ -n "$branch" ]]; then
		printf "$bold "

		local stats=$(git diff --shortstat 2>/dev/null | tail -n1)

		if [[ -n "$stats" ]]; then
			printf "${inverse}*"
		fi

		echo "$branch${r}"
	fi
}

PS1="${y}\$(date +%H:%M:%S)${r}${c}\$(git_branch) ${b}\w ${r}$ "

PROMPT_COMMAND=${PROMPT_COMMAND:+${PROMPT_COMMAND%;}; }osc7_cwd
