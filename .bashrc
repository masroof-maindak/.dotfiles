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
	local file_path="03 - Journal/$(date +'%m - %b')/${today}.md"
	if [[ ! -f "$file_path" ]]; then
		cd - >/dev/null
		echo "File doesn't exist yet..."
		return 1
	fi
	$EDITOR "$file_path"
	cd - >/dev/null
}

# Find *.md file in vault
fiv() {
	vlt
	file="$(fd -t f -e md -E '.*' | fzf --prompt "Vault: ")"
	[ -n "$file" ] && $EDITOR "$file"
	cd - >/dev/null
}

# Prompt
parse_git_branch() {
	git branch 2>/dev/null | sed -n '/\* /s///p' | sed 's/^/ (/;s/$/)/'
}

export PS1="\[\033[34m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] ·» "

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
