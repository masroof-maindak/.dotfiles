#!/bin/bash
source utils.sh

install_paru

# Make hardcoded directories
print_yellow "Making directories"
mkdir -p "$HOME"/{Screenshots,Desktop,Documents,Downloads,Music,Pictures/Wallpapers}
mkdir -p "$HOME"/{.local/bin,.themes,.icons,.config/vesktop/settings}
mkdir -p "$HOME"/Documents/{uni,prgrms,Vault,wrk,book}
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d

# Symlink dotfiles
print_yellow "Symlinking dotfiles"
stow .

choose_display_server

install_rust

# Install packages
installList "base"
if [ "$display_server" = "x11" ]; then
	installList "x11"
else
	installList "wayland"
fi

install_eww

# Mac Specific
device=$(cat /sys/class/dmi/id/product_name)
if echo "$device" | grep -q "MacBook"; then
	print_yellow "MacBook detected"

	# Install mbpfan
	print_yellow "Installing mbpfan"
	paru -S mbpfan-git

	# System files
	print_yellow "Copying system files"
	sudo cp ./system/Macbook/hid_apple.conf /etc/modprobe.d/hid_apple.conf
	sudo cp ./system/Macbook/30-touchpad.conf /etc/X11/xorg.conf.d/30-touchpad.conf

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
sudo cp ./system/pacman.conf /etc/pacman.conf
sudo cp ./system/skip-username.conf /etc/systemd/system/getty@tty1.service.d/skip-username.conf

# Services
print_yellow "Enabling services"
sudo systemctl enable NetworkManager

# Custom Desktop Entries
print_yellow "Copying desktop entries"
sudo cp ./system/Desktop/syncthing.desktop /usr/share/applications/syncthing.desktop
sudo cp ./system/Desktop/spotify_player.desktop /usr/share/applications/spotify_player.desktop
sudo cp ./system/Desktop/org.rnd2.cpupower_gui.desktop /usr/share/applications/org.rnd2.cpupower_gui.desktop

# Make scripts executable
print_yellow "Making scripts executable"
chmod +x "$HOME"/.config/bspwm/*
chmod +x "$HOME"/.config/eww/scripts/*
chmod +x "$HOME"/.config/polybar/scripts/*
chmod +x "$HOME"/.config/rofi/scripts/*
chmod +x "$HOME"/.config/berry/autostart
chmod +x "$HOME"/.local/bin/*

install_spotify_player

set_up_papirus

set_up_ssh
