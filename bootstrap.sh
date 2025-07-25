#!/bin/bash
source utils.sh

install_paru

print_yellow "Making directories"
mkdir -p "$HOME"/{Screenshots,Desktop,Documents,Downloads,Music,Pictures/{Wallpapers,Image\ Transmission},Videos}
mkdir -p "$HOME"/{.local/bin,.themes,.icons,.fonts,.config/{x11,gtk-2.0},.cache/{bash,python-history,mpd}}
mkdir -p "$HOME"/Documents/{uni,repos,Vault,wrk,books}
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d

install_rust

# Install packages
install_list "base"
install_list "wayland"

# Symlink dotfiles
rm "$HOME"/.bashrc "$HOME"/.bash_profile
print_yellow "Symlinking dotfiles"
stow .

# Mac Specific
device=$(cat /sys/class/dmi/id/product_name)
if echo "$device" | grep -q "MacBook"; then
	print_yellow "MacBook detected"

	print_yellow "Installing mbpfan"
	paru -S mbpfan-git

	# Swap keys
	print_yellow "Copying system files"
	sudo cp ./system/Macbook/hid_apple.conf /etc/modprobe.d/hid_apple.conf

	print_yellow "Enabling services"
	sudo systemctl enable mbpfan

	print_yellow "Regenerating initramfs"
	# sudo dracut --regenerate-all --force              # Use this on non-Arch based distros
	# mkinitcpio -p linux                               # For Arch, but didn't work for me so;
	sudo pacman -S linux
fi

# System files
print_yellow "Copying system files"
sudo cp ./system/pacman.conf /etc/pacman.conf
sudo cp ./system/skip-username.conf /etc/systemd/system/getty@tty1.service.d/skip-username.conf
sudo cp ./system/30-touchpad.conf /etc/X11/xorg.conf.d/30-touchpad.conf

# Services
print_yellow "Enabling services"
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now firewalld
systemctl enable --user --now mpd
systemctl enable --user --now mpd-mpris

# Custom Desktop Entries
print_yellow "Copying desktop entries"
sudo cp ./system/desktop-entries/syncthing.desktop /usr/share/applications/syncthing.desktop
sudo cp ./system/desktop-entries/spotify_player.desktop /usr/share/applications/spotify_player.desktop

# Make scripts executable
print_yellow "Making scripts executable"
chmod +x "$HOME"/.config/bspwm/*
chmod +x "$HOME"/.config/eww*/scripts/*
chmod +x "$HOME"/.config/polybar/scripts/*
chmod +x "$HOME"/.config/berry/autostart
chmod +x "$HOME"/.config/river/*
chmod +x "$HOME"/.local/bin/*

# Update this repo's remote
cd
cd .dotfiles
git remote set-url origin git@github.com:masroof-maindak/.dotfiles.git

# Source bashrc in current shell
source ~/.bashrc
