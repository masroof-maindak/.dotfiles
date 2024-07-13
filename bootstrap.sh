#!/bin/bash

print_yellow() {
    echo -e "\033[1;33m$1\033[0m"
}

# Install paru
print_yellow "Installing paru"
git clone https://aur.archlinux.org/paru.git
cd paru || exit
makepkg -si
cd ..
rm -rf paru

# Install st
print_yellow "Installing st"
git clone https://github.com/siduck/st
cd st || exit
sudo make && sudo make install
cd ..
rm -rf st

# Make hardcoded directories
print_yellow "Making directories"
mkdir -p "$HOME"/{Screenshots,Desktop,Downloads,Music,Pictures/Wallpapers}
mkdir -p "$HOME"/{.local/bin,.themes,.icons,.config/vesktop/settings}
mkdir -p "$HOME"/Documents/{uni,prgrms,Vault}

# Symlink dotfiles
print_yellow "Symlinking dotfiles"
stow .

# Install packages
print_yellow "Installing packages"
chmod +x packageInstall.sh
./packageInstall.sh

# Install Rust
print_yellow "Installing Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y

# Install Eww for X11
print_yellow "Installing Eww"
display_server="x11"
echo "Is this going to be a Wayland session? (y/n)"
read -r wayland
if [ "$wayland" = "y" ]; then
    display_server="wayland"
fi
git clone https://github.com/elkowar/eww ~/Documents/Programs/eww
cd ~/Documents/Programs/eww || exit
cargo build -r --no-default-features --features $display_server
sudo mv target/release/eww "$HOME"/.local/bin
chmod +x "$HOME"/.local/bin/eww

# Mac Specific
device=$(cat /sys/class/dmi/id/product_name)
if echo "$device" | grep -q "MacBook"; then
    print_yellow "MacBook detected"

    # Install mbpfan
    print_yellow "Installing mbpfan"
    paru -S mbpfan-git

    # System files
    print_yellow "Copying system files"
    sudo mv ./system/hid_apple.conf                     /etc/modprobe.d/hid_apple.conf
    sudo mv ./system/30-touchpad.conf                   /etc/X11/xorg.conf.d/30-touchpad.conf
    sudo mv ./system/org.rnd2.cpupower_gui.desktop      /usr/share/applications/org.rnd2.cpupower_gui.desktop
    
    # Services
    print_yellow "Enabling services"
    sudo systemctl enable mbpfan

    # Regenerate initramfs
    print_yellow "Regenerating initramfs"
    # sudo dracut --regenerate-all --force              # Use this on non-Arch based distros
    # mkinitcpio -p linux                               # For Arch, but didn't work for me so;
    sudo pacman -S linux  
fi

# System files
print_yellow "Copying system files"
sudo mv ./system/pacman.conf                        /etc/pacman.conf

# Services
print_yellow "Enabling services"
sudo systemctl enable NetworkManager

# Custom Desktop Entries
print_yellow "Copying desktop entries"
sudo mv ./system/syncthing.desktop                  /usr/share/applications/syncthing.desktop
sudo mv ./system/spotify_player.desktop             /usr/share/applications/spotify_player.desktop

# Make scripts executable
print_yellow "Making scripts executable"
chmod +x "$HOME"/.config/bspwm/*
chmod +x "$HOME"/.config/eww/scripts/*
chmod +x "$HOME"/.config/polybar/scripts/*
chmod +x "$HOME"/.config/rofi/scripts/*
chmod +x "$HOME"/.config/berry/autostart

# Install spotify-player
print_yellow "Installing spotify-player"
git clone https://github.com/aome510/spotify-player.git "$HOME"/Documents/Programs/spotify-player
cd "$HOME"/Documents/Programs/spotify-player || exit
cargo build -r --features lyric-finder,notify
mv target/release/spotify_player "$HOME"/.local/bin/spotify_player
chmod +x "$HOME"/.local/bin/spotify_player

# Papirus Icon Theme
print_yellow "Installing Papirus Icon Theme"
wget -qO- https://git.io/papirus-icon-theme-install | sh
wget -qO- https://git.io/papirus-folders-install | sh
