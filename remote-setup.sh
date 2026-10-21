#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")"
source /etc/os-release

have() { command -v "$1" >/dev/null 2>&1; }
installed() { dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q 'install ok installed'; }

# fish 4 repo
case "$ID:$VERSION_ID" in
ubuntu:*)
    if ! grep -rqs 'fish-shell/release-4' /etc/apt/sources.list.d; then
        sudo add-apt-repository -y ppa:fish-shell/release-4
    fi
    ;;
debian:12 | debian:13)
    list=/etc/apt/sources.list.d/shells:fish:release:4.list
    if [ ! -f "$list" ]; then
        repo="shells:/fish:/release:/4/Debian_${VERSION_ID}"
        curl -fsSL "https://download.opensuse.org/repositories/$repo/Release.key" | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_4.gpg >/dev/null
        echo "deb https://download.opensuse.org/repositories/$repo/ /" | sudo tee "$list" >/dev/null
    fi
    ;;
*)
    echo "Unsupported OS: $PRETTY_NAME" >&2
    exit 1
    ;;
esac

missing=()
for pkg in fish vim fd-find zoxide snapd clang; do
    installed "$pkg" || missing+=("$pkg")
done
if [ ${#missing[@]} -gt 0 ]; then
    sudo apt update
    sudo apt install -y "${missing[@]}"
fi

# tmux (distro versions < 3.4 break swamp-mode)
if [ "$(tmux -V 2>/dev/null)" != "tmux 3.7c" ]; then
    curl -fsSL "https://github.com/tmux/tmux-builds/releases/download/v3.7c/tmux-3.7c-linux-$(uname -m | sed s/aarch64/arm64/).tar.gz" |
        sudo tar -xz --no-same-owner -C /usr/local/bin tmux
    if installed tmux; then
        sudo apt remove -y tmux
    fi
    hash -r
fi

# configs; drop the distro's default fish config so ours can be linked
[ -L ~/.config/fish/config.fish ] || rm -rf ~/.config/fish
make stow-remote

# env (CARGO_HOME, GOBIN, PATH, RUSTC_WRAPPER, ...) from the freshly linked profile
set +u
source ~/.bash_profile
set -u
export PATH="/snap/bin:$PATH"

# sccache (RUSTC_WRAPPER; not packaged on older distros)
have sccache || curl -fsSL "https://github.com/mozilla/sccache/releases/download/v0.18.0/sccache-v0.18.0-$(uname -m)-unknown-linux-musl.tar.gz" |
    tar -xz -C ~/.local/bin --strip-components=1 --wildcards '*/sccache'

# Rust + tools
have rustup || curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
have tree-sitter || cargo install tree-sitter-cli --locked
have bat || cargo install bat --locked
grep -qx swamp-dark <(bat --list-themes) || bat cache --build

# Neovim, Go
snap list nvim >/dev/null 2>&1 || sudo snap install nvim --classic
snap list go >/dev/null 2>&1 || sudo snap install go --classic

# fzf
fzf_dir=~/Documents/repos/fzf
[ -d "$fzf_dir" ] || git clone --depth 1 https://github.com/junegunn/fzf.git "$fzf_dir"
[ -x "$fzf_dir/bin/fzf" ] || "$fzf_dir/install" --bin
ln -sf "$fzf_dir/bin/fzf" "$HOME/.local/bin/fzf"

# lf
have lf || CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/gokcehan/lf@latest

# delta
if ! have delta; then
    deb="git-delta_0.19.2_$(dpkg --print-architecture).deb"
    tmp=$(mktemp -d)
    curl -fsSL -o "$tmp/$deb" "https://github.com/dandavison/delta/releases/download/0.19.2/$deb"
    sudo apt install -y "$tmp/$deb"
    rm -rf "$tmp"
fi
