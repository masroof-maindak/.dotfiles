# Env Vars
export EDITOR=nvim
export VISUAL=nvim
export SUDOEDITOR=nvim
export MANPAGER='nvim +Man!'

export GOPATH="$HOME/.go"
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/.ripgreprc"

export FZF_DEFAULT_COMMAND="fd . --hidden --exclude \".git\""
export FZF_DEFAULT_OPTS="--reverse --margin 1,2 --prompt \"fzf: \" --color=16 --preview-window=\"down,50%,border-sharp,wrap\" --multi"

export ELECTRON_OZONE_PLATFORM_HINT=auto
export SWWW_TRANSITION=none
export SDL_VIDEODRIVER=wayland

export VAULT_DIR="$HOME/Documents/Vault/"

export XDG_CONFIG_HOME="$HOME/.config"

export PYTHON_HISTORY="$HOME/.cache/python-history/hist"

# PATH entries
add_to_path() {
	[[ ":$PATH:" != *":$1:"* ]] && export PATH="$1:$PATH"
}

add_to_path "$HOME/.local/bin"
add_to_path "$(go env GOPATH)/bin"
add_to_path "$HOME/.cargo/bin"

# Source bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc
