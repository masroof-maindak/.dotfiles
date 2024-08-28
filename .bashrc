# If not running interactively, don't do anything
[[ $- != *i* ]] && return

parse_git_branch() {
	git branch 2>/dev/null | sed -n '/\* /s///p' | sed 's/^/ (/;s/$/)/'
}

export PS1="\[\033[34m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

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

# Shitty bash zoxide...
to() {
	local base_dir=""
	local sub_path=""
	for arg in "$@"; do
		if [[ -n "${DIRS[$arg]}" ]]; then
			base_dir="${DIRS[$arg]}"
			sub_path=""
		else
			sub_path+="/$arg"
		fi
	done

	local path="$base_dir$sub_path"

	if [ -d "$path" ]; then
		cd "$path"
	else
		echo "Directory does not exist: $path"
		return 1
	fi
}

# Open today's journal entry
jrnl() {
	local today=$(date +'%m-%d')
	local vault_path=${DIRS["vlt"]}
	local file_path="${vault_path}/03 - Journal/$(date +'%m - %b')/${today}.md"
	if [[ ! -f "$file_path" ]]; then
		echo "File doesn't exist yet..."
		return 1
	fi
	$EDITOR "$file_path"
}

# Find *.md file in vault
fiv() {
	vlt
	file="$(fd -t f -e md -E '.*' | fzf --prompt "Vault: ")"
	[ -n "$file" ] && $EDITOR "$file"
	cd - >/dev/null
}
