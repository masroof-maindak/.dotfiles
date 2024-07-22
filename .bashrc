# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Prompt
PROMPT_COMMAND='PS1X=$(perl -p -e "s|^${HOME}|~|;s|([^/])[^/]*/|$""1/|g" <<<${PWD})'
PROMPT1='\[\e[91;1m\]${PS1X}\[\e[0m\] % '
# ---
parse_git_branch() {
	git branch 2>/dev/null | sed -n '/\* /s///p' | sed 's/^/ (/;s/$/)/'
}
PROMPT2="\[\033[01;34m\]\w\[\033[01;33m\]\$(parse_git_branch)\[\033[00m\] % "
export PS1=$PROMPT1

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

chng-prmpt() {
	if [ "$PS1" = "$PROMPT1" ]; then
		export PS1=$PROMPT2
	else
		export PS1=$PROMPT1
	fi
	clear
}

fzchk() {
	if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		git checkout $(git branch | fzf)
	else
		echo "Not a git repository"
	fi
}

# to() {
#     local base_dir=""
#
#     case $1 in
#         scr) base_dir="$HOME/Screenshots";;
#         mus) base_dir="$HOME/Music";;
#         vid) base_dir="$HOME/Videos";;
#         pic) base_dir="$HOME/Pictures";;
#         dow) base_dir="$HOME/Downloads";;
#         doc) base_dir="$HOME/Documents";;
#         dot) base_dir="$HOME/.dotfiles";;
#         uni) base_dir="$HOME/Documents/uni";;
#         cfg) base_dir="$HOME/.config";;
#         *) echo "Unknown base directory: $1"; return 1;;
#     esac
#
#     shift
#     local target_dir="$base_dir/$*"
#
#     if [ -d "$target_dir" ]; then
#         cd "$target_dir"
#     else
#         echo "Directory does not exist: $target_dir"
#         return 1
#     fi
# }


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
