set -x EDITOR nvim
set -x VISUAL nvim
set -x SUDOEDITOR nvim

set -x BROWSER librewolf
set -x MANPAGER 'nvim +Man!'
set -x VAULT_DIR "$HOME/Documents/Vault/"

# XDG
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x XDG_CACHE_HOME "$HOME/.cache"
set -x XDG_DATA_HOME "$HOME/.local/share"
set -x XDG_STATE_HOME "$HOME/.local/state"

set -x CARGO_HOME "$XDG_DATA_HOME/cargo"
set -x RUSTUP_HOME "$XDG_DATA_HOME/rustup"
set -x RUSTC_WRAPPER "sccache"
set -x BINSTALL_DISABLE_TELEMETRY "true"

set -x GOPATH "$XDG_DATA_HOME/go"
set -x GOBIN "$GOPATH/bin"
set -x GOMODCACHE "$XDG_CACHE_HOME/go/mod"

set -x RUFF_CACHE_DIR "$XDG_CACHE_HOME/ruff"
set -x PYTHON_HISTORY "$XDG_CACHE_HOME/python-history/hist"
set -x PYENV_ROOT "$XDG_DATA_HOME/pyenv"

set -x NODE_REPL_HISTORY "$XDG_DATA_DATA/node_repl_history"
set -x _JAVA_OPTIONS "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"

set -x SQLITE_HISTORY "$XDG_STATE_HOME/sqlite_history"

set -x WGETRC "$XDG_CONFIG_HOME/wgetrc"
set -x GTK2_RC_FILES "$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
set -x RIPGREP_CONFIG_PATH "$XDG_CONFIG_HOME/ripgrep/.ripgreprc"

# Software
set -x FZF_DEFAULT_COMMAND "fd . --hidden --exclude \".git\""
set -x FZF_DEFAULT_OPTS "--reverse --margin 1,2 --prompt \"fzf: \" --color=16,current-bg:0,border:0 --preview-window=\"down,50%,border-sharp,wrap\" --multi"

# Wayland
set -x ELECTRON_OZONE_PLATFORM_HINT auto
set -x SWWW_TRANSITION none
set -x SDL_VIDEODRIVER wayland

# PATH entries
fish_add_path "$HOME/.local/bin"
fish_add_path "$CARGO_HOME/bin"
fish_add_path "$GOBIN"
