# Directories
declare -A DIRS=(
	[wrk]="$HOME/Documents/wrk/"

	[vlt]="$VAULT_DIR"
	[uni]="$HOME/Documents/uni"
	[dow]="$HOME/Downloads"
	[doc]="$HOME/Documents"
	[rep]="$HOME/Documents/repos"
	[des]="$HOME/Desktop"
	[scr]="$HOME/Screenshots"
	[mus]="$HOME/Music"
	[vid]="$HOME/Videos"
	[dot]="$HOME/.dotfiles"
	[cfg]="$HOME/.config"
)

for key in "${!DIRS[@]}"; do
	alias $key="cd ${DIRS[$key]}"
done

# Git - More in config
alias g="git"
alias gco="fzchk"
alias gs="git status"
alias gss="git status -s"
alias gitls="git config --list | grep alias"

# Software
alias dd="dragon-drop -a -s 72"
alias v="nvim"
alias p="pacman"
alias py="python"
alias l="lfcd"
alias dk="docker"
alias z="zellij"

# Builtins
alias ls="ls -hN --color=auto --group-directories-first"
alias c="clear"
alias clera="clear"
alias q="exit"
alias quit="exit"
alias qquit="exit"
alias mkdir="mkdir -p"
alias dt="date"
alias cd..="cd ../.."

# Functions
alias pubip='curl ipinfo.io; echo'
alias copy='wl-copy <'
alias pkg="pacman -Q | wc -l"
alias bt="upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | awk '{print $2}'"
