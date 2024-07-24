# Directories
declare -A DIRS=(
    [cur]="$HOME/Documents/wrk/nayavpn"
    [cur2]="$HOME/Documents/wrk2/EducationVerse-App-Backend/"

	[vlt]="$HOME/Documents/Vault"
	[uni]="$HOME/Documents/uni"
	[dow]="$HOME/Downloads"
	[doc]="$HOME/Documents"
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

# Git
alias gam="commit --amend"
alias gdag="git log --graph --oneline --all"
alias g="git"
alias ga="git add"
alias gaa="git add --all"
alias gac="git add . && git commit -m"
alias gc="git commit"
alias gcl="git clone"
alias gcm="git commit -m"
alias gco="fzchk"
alias gl="git pull"
alias gp="git push"
alias grev="git revert"
alias grm="git rm"
alias gs="git status"
alias gss="git status -s"

# Software
alias grep="rg"
alias dd="dragon-drop"
alias v="nvim"
alias p="pacman"
alias py="python"
alias l="lfcd"
alias dk="docker"

# Builtins
alias ls="ls -hN --color=auto --group-directories-first"
alias c="clear"
alias q="exit"
alias mkdir="mkdir -p"

# Startx
alias bsp="startx $HOME/.xinitrc bspwm"
alias ber="startx $HOME/.xinitrc berry"

# Configs
alias brc="$EDITOR $HOME/.bashrc"
alias bsc="$EDITOR $HOME/.config/bspwm/bspwmrc"
alias sxc="$EDITOR $HOME/.config/sxhkd/sxhkdrc"

# Functions
alias pubip='curl ipinfo.io/ip'
alias copy='xclip -selection clipboard <'
alias pkg="pacman -Q | wc -l"
alias bt="upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage"
