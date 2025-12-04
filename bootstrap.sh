#!/usr/bin/env bash

source utils.sh
source .bash_profile

print_yellow "Making directories"
if [ -z "$XDG_DATA_HOME" ]; then
    export XDG_DATA_HOME="$HOME/.local/share"
    print_yellow "WARNING: XDG_DATA_HOME not set, falling back to $XDG_DATA_HOME"
fi
if [ -z "$XDG_CACHE_HOME" ]; then
    export XDG_CACHE_HOME="$HOME/.cache"
    print_yellow "WARNING: XDG_CACHE_HOME not set, falling back to $XDG_CACHE_HOME"
fi
if [ -z "$XDG_STATE_HOME" ]; then
    export XDG_STATE_HOME="$HOME/.local/state"
    print_yellow "WARNING: XDG_STATE_HOME not set, falling back to $XDG_STATE_HOME"
fi

mkdir -p "$HOME"/{Screenshots,Desktop,Documents,Downloads,Music,Pictures/{Wallpapers,Image\ Transmission},Videos}
mkdir -p "$HOME"/{.local/bin,.themes,.icons,.fonts,.config/gtk-2.0}
mkdir -p "$HOME"/Documents/{uni,repos,Vault,wrk,books,projects}

mkdir -p "$XDG_STATE_HOME"/vim
mkdir -p "$XDG_CACHE_HOME"/{bash,python-history,mpd,ruff,go}
mkdir -p "$XDG_DATA_HOME"/{cargo,go,pyenv}

sudo mkdir -p /etc/systemd/system/getty@tty1.service.d

# Install packages
if [ -z "$(command -v paru)" ]; then
    sudo pacman -S --needed base-devel
    install_paru
fi
install_pacman_list "./system/package-lists/package_list.md"

# Symlink dotfiles
rm -f "$HOME"/.bashrc "$HOME"/.bash_profile
if [ "$(pwd -P)" != "$HOME/.dotfiles" ]; then
    print_yellow "Error: script must be run from $HOME/.dotfiles (current: $(pwd -P))"
    exit 1
fi
print_yellow "Symlinking dotfiles"
stow .

# Mac Specific
device=$(cat /sys/class/dmi/id/product_name)
if echo "$device" | grep -q "MacBook"; then
    print_yellow "MacBook detected"

    # Swap keys
    print_yellow "Copying system files"
    sudo cp ./system/Macbook/hid_apple.conf /etc/modprobe.d/hid_apple.conf

    # If mbpfan-git already installed, skip fan-install steps
    if pacman -Qi mbpfan-git &>/dev/null; then
        print_yellow "mbpfan-git already installed — skipping fan install"
    else
        # Fan Fix
        print_yellow "Installing mbpfan"
        paru -S --noconfirm mbpfan-git
    fi

    print_yellow "Enabling services"
    sudo systemctl enable --now mbpfan

    print_yellow "Regenerating initramfs"
    # sudo dracut --regenerate-all --force     # Use this on non-Arch based distros
    # mkinitcpio -p linux                      # For Arch, but didn't work for me so;
    sudo pacman -S linux
fi

# System files
print_yellow "Copying system files"
sudo cp ./system/pacman.conf /etc/pacman.conf
sudo cp ./system/skip-username.conf /etc/systemd/system/getty@tty1.service.d/skip-username.conf

# Services
print_yellow "Enabling services"
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now ufw # TODO: first-time setup?
systemctl enable --user --now mpd
systemctl enable --user --now mpd-mpris

# Custom Desktop Entries
print_yellow "Copying desktop entries"
sudo cp ./system/desktop-entries/syncthing.desktop /usr/share/applications/syncthing.desktop
sudo cp ./system/desktop-entries/spotify_player.desktop /usr/share/applications/spotify_player.desktop

# Make scripts executable
print_yellow "Making scripts executable"
chmod +x "$HOME"/.local/bin/*

# Set up Rust tooling
print_yellow "Setting up Rust & tools"
rustup default stable

# Install Swamp Light for bat
if [ -z "$(command -v bat)" ]; then
    bat cache --build
fi

# Install Rust programs
install_rust_list "./system/package-lists/rust"
install_rust_binary "https://github.com/elkowar/eww" "eww" "--no-default-features --features wayland"
install_rust_binary "https://github.com/druskus20/eww-niri-workspaces.git" "eww-niri-workspaces" ""

# Set up fish
print_yellow "Setting up Fish shell"
chsh -s "$(which fish)"
fisher update
