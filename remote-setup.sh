# Install deps & fish
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
sudo apt install fish vim sccache tmux fd-find zoxide snap snapd

# symlink configs
## Scrap the fish config that usually gets created by default upon install
rm -rf ~/.config/fish
make stow-remote

# install rustup
if ! command -v rustup >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# Neovim
if ! command -v nvim >/dev/null 2>&1; then
    sudo snap install nvim --classic
fi

cargo install tree-sitter-cli --locked

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

# bat
cargo install bat
bat cache --build

# delta
curl -LO https://github.com/dandavison/delta/releases/download/0.19.2/git-delta_0.19.2_arm64.deb
sudo dpkg -i git-delta_0.19.2_arm64.deb
rm git-delta_0.19.2_arm64.deb
