# Env Vars
export EDITOR=nvim
export VISUAL=nvim
export SUDOEDITOR=nvim
export MANPAGER='nvim +Man!'

export GOPATH="$HOME/.go"
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/.ripgreprc"

export ELECTRON_OZONE_PLATFORM_HINT=auto
export FZF_DEFAULT_OPTS="--reverse --margin 2 --prompt \"fzf: \""
export SWWW_TRANSITION=none
export SDL_VIDEODRIVER=wayland

# PATH entries
add_to_path() {
	[[ ":$PATH:" != *":$1:"* ]] && export PATH="$1:$PATH"
}

add_to_path "$HOME/.local/bin"
add_to_path "$(go env GOPATH)/bin"
add_to_path "$HOME/.cargo/bin"

# Source bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc
