# Env Vars
export TERM=foot
export TERMINAL=foot

export EDITOR=nvim
export VISUAL=nvim
export SUDOEDITOR=nvim

export BROWSER=librewolf
export MANPAGER='nvim +Man!'

# XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export XINITRC="$XDG_CONFIG_HOME/x11/xinitrc"
export XPROFILE="$XDG_CONFIG_HOME/x11/xprofile"
export XRESOURCES="$XDG_CONFIG_HOME/x11/xresources"

export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

export GOPATH="$XDG_DATA_HOME/go"
export GOBIN="$GOPATH/bin"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"

export RUFF_CACHE_DIR="$XDG_CACHE_HOME/ruff"
export PYTHON_HISTORY="$XDG_CACHE_HOME/python-history/hist"

export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java

export SQLITE_HISTORY=$XDG_STATE_HOME/sqlite_history

export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/.ripgreprc"

# Software
export FZF_DEFAULT_COMMAND="fd . --hidden --exclude \".git\""
export FZF_DEFAULT_OPTS="--reverse --margin 1,2 --prompt \"fzf: \" --color=16 --preview-window=\"down,50%,border-sharp,wrap\" --multi"

# Wayland
export ELECTRON_OZONE_PLATFORM_HINT=auto
export SWWW_TRANSITION=none
export SDL_VIDEODRIVER=wayland

export VAULT_DIR="$HOME/Documents/Vault/"


# PATH entries
add_to_path() {
	[[ ":$PATH:" != *":$1:"* ]] && export PATH="$1:$PATH"
}

add_to_path "$HOME/.local/bin"
add_to_path "$CARGO_HOME/bin"
add_to_path "$GOBIN"

# Source bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc
