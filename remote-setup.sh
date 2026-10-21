#!/usr/bin/env bash

source /etc/os-release

case "$ID:$VERSION_ID" in
ubuntu:*)
    sudo add-apt-repository -y ppa:fish-shell/release-4
    ;;

debian:12 | debian:13)
    repo="shells:/fish:/release:/4/Debian_${VERSION_ID}"
    echo "deb https://download.opensuse.org/repositories/$repo/ /" | sudo tee "/etc/apt/sources.list.d/shells:fish:release:4.list" >/dev/null
    curl -fsSL "https://download.opensuse.org/repositories/$repo/Release.key" | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_4.gpg >/dev/null
    ;;

*)
    echo "Unsupported OS: $PRETTY_NAME" >&2
    exit 1
    ;;
esac

sudo apt update
sudo apt install -y fish vim sccache fd-find zoxide snap snapd

# tmux (distro versions < 3.4 break swamp-mode)
case "$(uname -m)" in
x86_64) tmux_arch=x86_64 ;;
aarch64 | arm64) tmux_arch=arm64 ;;
*) tmux_arch="" ;;
esac
if [ -n "$tmux_arch" ]; then
    curl -fsSL "https://github.com/tmux/tmux-builds/releases/download/v3.7c/tmux-3.7c-linux-$tmux_arch.tar.gz" |
        sudo tar -xz -C /usr/local/bin tmux
else
    echo "No tmux build for $(uname -m); installing the distro package" >&2
    sudo apt install -y tmux
fi

# symlink configs
## Scrap the fish config that usually gets created by default upon install
rm -rf ~/.config/fish
make stow-remote

# install rustup and Rust tools inside fish
fish -c '
    if not command -q rustup
        curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    end

    if test -f "$HOME/.cargo/env"
        source "$HOME/.cargo/env"
    end

    if not command -q tree-sitter
        cargo install tree-sitter-cli --locked
    end

    if not command -q bat
        cargo install bat
    end

    if command -q bat
        bat cache --build
    end
'

# Neovim
if ! command -v nvim >/dev/null 2>&1; then
    sudo snap install nvim --classic
fi

# fzf
mkdir -p ~/Documents/repos
cd ~/Documents/repos

if [ ! -d fzf ]; then
    git clone https://github.com/junegunn/fzf.git --depth 2
fi

cd fzf
echo 'n\nn\nn\n' | ./install

# lf
sudo snap install go --classic

fish -c '
    if not command -q lf
        env CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/gokcehan/lf@latest
    end
'

# delta
if ! command -v delta >/dev/null 2>&1; then
    arch="$(dpkg --print-architecture)"
    deb="git-delta_0.19.2_${arch}.deb"
    curl -fLO "https://github.com/dandavison/delta/releases/download/0.19.2/$deb"
    sudo apt install -y "./$deb"
    rm "$deb"
fi
