#!/usr/bin/env bash

print_yellow() {
    echo -e "\033[1;33m$1\033[0m"
}

install_paru() {
    print_yellow "Installing paru"
    git clone https://aur.archlinux.org/paru.git
    cd paru || exit
    RUSTC_WRAPPER="" makepkg -si
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
            cargo binstall -y "$pkg"
        fi
    done <"$1"
}

install_python_list() {
    print_yellow "Installing packages from $1"
    while read -r pkg; do
        if [[ -n "$pkg" && ! "$pkg" =~ ^# ]]; then
            uv tool install "$pkg"
        fi
    done <"$1"
}
