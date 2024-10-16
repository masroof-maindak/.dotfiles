# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Unlimited history
HISTSIZE=-1
HISTFILESIZE=-1

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
parse_git_branch() {
	git branch 2>/dev/null | sed -n '/\* /s///p' | sed 's/^/ (/;s/$/)/'
}

export PS1="\[\033[34m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

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

PROMPT_COMMAND=${PROMPT_COMMAND:+${PROMPT_COMMAND%;}; }osc7_cwd
