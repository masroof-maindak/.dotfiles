#
# ~/.bash_profile
#

# Env Vars
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export GDK_SCALE=2
export GDK_DPI_SCALE=0.5

export TERM=st
export TERMINAL=st

export EDITOR=nvim
export VISUAL=nvim
export SUDOEDITOR=nvim

export GOPATH="$HOME/.go"
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/.ripgreprc"

# PATH entries
add_to_path() {
	[[ ":$PATH:" != *":$1:"* ]] && export PATH="$1:$PATH"
}

add_to_path "$HOME/.local/bin"
add_to_path "$(go env GOPATH)/bin"
add_to_path "$HOME/.cargo/bin"

# Source bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc
