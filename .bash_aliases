# Git - More in config
alias g="git"
alias gs="git status"
alias gss="git status -s"
alias gitls="git config --list | grep alias"

# Software
alias dd="dragon-drop -a -s 72"
alias v="nvim"
alias p="pacman"
alias py="python"
alias l="lfcd"
alias m="make"
alias dk="docker"
alias uvr="uv run"
alias uvm="uv run manage.py"

# Builtins
alias ls="ls -hN --color=auto --group-directories-first"
alias c="clear"
alias clera="clear"
alias q="exit"
alias quit="exit"
alias qquit="exit"
alias md="mkdir -p"

# Functions
alias pubip='curl ipinfo.io; echo'
alias copy='wl-copy <'
alias pkg="pacman -Q | wc -l"
alias bt="upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | awk '{print $2}'"
