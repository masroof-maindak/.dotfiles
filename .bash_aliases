alias wrk="cd ~/Documents/wrk/"
alias wrk2="cd ~/Documents/wrk2/"
alias cur="cd ~/Documents/wrk/nayavpn"
alias cur2="cd ~/Documents/wrk2/EducationVerse-App-Backend/"

# Git
alias amend="commit --amend"
alias graph="log --graph --oneline --all"
alias g="git"
alias ga="git add"
alias gaa="git add --all"
alias gac="git add . && git commit -m"
alias gc="git commit"
alias gcl="git clone"
alias gcm="git commit -m"
alias gco="git checkout"
alias ggl="git pull"
alias ggp="git push"
alias grev="git revert"
alias grm="git rm"
alias gs="git status"
alias gss="git status -s"

# Software
alias grep="rg"
alias dd="dragon-drop"
alias v="nvim"
alias p="pacman"
alias l="lfcd"

# Builtins
alias ls="ls -hN --color=auto --group-directories-first"
alias c="clear"
alias q="exit"

# Directories
alias scr="cd ~/Screenshots/"
alias dow="cd ~/Downloads/"
alias doc="cd ~/Documents/"
alias dev="cd ~/Documents/dev/"
alias uni="cd ~/Documents/uni/"
alias dot="cd ~/.dotfiles/"
alias cfg="cd ~/.config/"

# Startx
alias bsp="startx ~/.xinitrc bspwm"
alias ber="startx ~/.xinitrc berry"
alias i3wm="startx ~/.xinitrc i3"

# Configs
alias brc="v ~/.bashrc"
alias bsc="v ~/.config/bspwm/bspwmrc"
alias i3c="v ~/.config/i3/config"
alias sxc="v ~/.config/sxhkd/sxhkdrc"

# Functions
alias pubip='curl ipinfo.io/ip'
alias copy='xclip -selection clipboard <'
alias pkg="pacman -Q | wc -l"
alias bt="upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage"
