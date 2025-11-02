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

install_rust_binary() {
    local repo_url="$1"
    local binary_name="$2"
    local build_args="$3"

    local repo_dir="$HOME"/Documents/repos/"$(basename "$repo_url" .git)"

    print_yellow "Cloning and setting up $binary_name from $repo_url"
    if [ -d "$repo_dir" ]; then
        print_yellow "$repo_dir already exists, pulling latest changes"
        cd "$repo_dir" || exit
        git pull
    else
        git clone "$repo_url" "$repo_dir"
        cd "$repo_dir" || exit
    fi

    cargo build -r "$build_args"
    mv target/release/"$binary_name" "$HOME"/.local/bin
    chmod +x "$HOME"/.local/bin/"$binary_name"
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
