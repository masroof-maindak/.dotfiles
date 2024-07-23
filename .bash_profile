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

# Add to path
[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && export PATH="$HOME/.local/bin:$PATH"
[[ ":$PATH:" != *":$(go env GOPATH)/bin:"* ]] && export PATH="$(go env GOPATH)/bin:$PATH"
[[ ":$PATH:" != *":$HOME/.cargo/bin:"* ]] && export PATH="$HOME/.cargo/bin:$PATH"

# Source bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc
