#!/bin/bash

print_yellow() {
	echo -e "\033[1;33m$1\033[0m"
}

install_paru() {
	print_yellow "Installing paru"
	git clone https://aur.archlinux.org/paru.git
	cd paru || exit
	makepkg -si
	cd ..
	rm -rf paru
}

install_st() {
	print_yellow "Installing st"
	git clone https://github.com/siduck/st
	git pull
	cd st || exit
	sudo make && sudo make install
	cd ..
	rm -rf st
}

install_rust() {
	print_yellow "Installing Rust"
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
}

installList() {
	print_yellow "Installing $1 packages"
	for pkg in $(cat ./system/packageLists/$1); do
    	if [[ -n "$pkg" && ! "$pkg" =~ ^# ]]; then
    	    if ! pacman -Q "$pkg" &>/dev/null; then
    	        paru -S --skipreview --noconfirm "$pkg"
    	    fi
    	fi
	done
}

install_eww() {
	print_yellow "Installing Eww"
	git clone https://github.com/elkowar/eww "$HOME"/Documents/repos/eww
	cd "$HOME"/Documents/repos/eww || exit
	git pull
	cargo build -r --no-default-features --features=wayland
	mv target/release/eww "$HOME"/.local/bin
	chmod +x "$HOME"/.local/bin/eww
	cd "$HOME"/.dotfiles/ || exit
}

install_spotify_player() {
	print_yellow "Installing spotify-player"
	git clone https://github.com/aome510/spotify-player.git "$HOME"/Documents/repos/spotify-player
	cd "$HOME"/Documents/repos/spotify-player || exit
	git pull
	cargo build -r --no-default-features --features notify,sixel,pulseaudio-backend,streaming,media-control
	mv target/release/spotify_player "$HOME"/.local/bin/spotify_player
	chmod +x "$HOME"/.local/bin/spotify_player
	cd "$HOME"/.dotfiles/ || exit
}

set_up_papirus() {
	print_yellow "Installing Papirus Icon Theme"
	wget -qO- https://git.io/papirus-icon-theme-install | sh
	wget -qO- https://git.io/papirus-folders-install | sh
}
