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

install_pacman_list() {
    print_yellow "Installing packages from $1"
    while read -r pkg; do
        if [[ -n "$pkg" && ! "$pkg" =~ ^# ]]; then
            if ! pacman -Q "$pkg" &>/dev/null; then
                paru -S --skipreview --noconfirm "$pkg"
            fi
        fi
    done <"$1"
}

install_rust_list() {
    print_yellow "Installing packages from $1"
    while read -r pkg; do
        if [[ -n "$pkg" && ! "$pkg" =~ ^# ]]; then
            cargo install "$pkg"
        fi
    done <"$1"
}

install_eww() {
    print_yellow "Installing Eww"
    git clone https://github.com/elkowar/eww "$HOME"/Documents/repos/eww
    cd "$HOME"/Documents/repos/eww || exit
    git pull
    cargo build -r --no-default-features --features wayland
    mv target/release/eww "$HOME"/.local/bin
    chmod +x "$HOME"/.local/bin/eww
    cd - || exit
}

install_wireguard_go() {
    print_yellow "Installing wireguard-go"
    git clone https://git.zx2c4.com/wireguard-go "$HOME"/Documents/repos/wireguard-go
    cd "$HOME"/Documents/repos/wireguard-go || exit
    git pull
    make
    sudo mv wireguard-go /usr/local/bin
    cd - || exit
}
