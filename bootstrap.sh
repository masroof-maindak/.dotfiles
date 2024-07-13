#!/usr/bin/sh

# Install paru
git clone https://aur.archlinux.org/paru.git
cd paru || exit
makepkg -si
cd ..
rm -rf paru

# Install st
git clone https://github.com/siduck/st
cd st || exit
sudo make && sudo make install
cd ..
rm -rf st

# Make hardcoded directories
mkdir -p "$HOME"/{Screenshots,Desktop,Downloads,Music,Pictures/Wallpapers,.local/bin}
mkdir -p "$HOME"/Documents/{uni,prgrms,Vault}

# Symlink dotfiles
stow .

# Install packages
./packageInstall.sh

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y

# Install Eww for X11
git clone https://github.com/elkowar/eww ~/Documents/Programs/eww
cd ~/Documents/Programs/eww || exit
cargo build -r --no-default-features --features x11
sudo mv target/release/eww $HOME/.local/bin
chmod +x $HOME/.local/bin/eww

# Mac Specific
device=$(cat /sys/class/dmi/id/product_name)
if echo "$device" | grep -q "MacBook"; then
    # System files
    sudo mv ./system/hid_apple.conf                     /etc/modprobe.d/hid_apple.conf
    sudo mv ./system/30-touchpad.conf                   /etc/X11/xorg.conf.d/30-touchpad.conf
    sudo mv ./system/org.rnd2.cpupower_gui.desktop      /usr/share/applications/org.rnd2.cpupower_gui.desktop
    
    # Services
    sudo systemctl enable mbpfan

    # Regenerate initramfs
    # mkinitcpio -p linux                               # Didn't work for me so;
    sudo pacman -S linux  
    # sudo dracut --regenerate-all --force              # Use this on non-Arch based distros
fi

# System files
sudo mv ./system/pacman.conf                        /etc/pacman.conf

# Services
sudo systemctl enable NetworkManager

# Custom Desktop Entries
sudo mv ./system/syncthing.desktop                  /usr/share/applications/syncthing.desktop
sudo mv ./system/spotify_player.desktop             /usr/share/applications/spotify_player.desktop

# Make scripts executable
chmod +x "$HOME"/.config/bspwm/*
chmod +x "$HOME"/.config/eww/scripts/*
chmod +x "$HOME"/.config/polybar/scripts/*
chmod +x "$HOME"/.config/rofi/scripts/*
chmod +x "$HOME"/.config/berry/autostart

# Install swamp GTK theme + Firefox chrome - universal
git clone https://github.com/masroof-maindak/swamp.nvim.git
cd swamp.nvim || exit
cd extras || exit
cd gtk || exit
make && sudo make install
cd ..
mv firefox/* "$HOME"/mozilla/firefox/*.default-release/chrome/
cd ../..
rm -rf swamp.nvim

# Install spotify-player
git clone https://github.com/aome510/spotify-player.git $HOME/Documents/Programs/spotify-player
cd $HOME/Documents/Programs/spotify-player || exit
cargo build -r --features lyric-finder,notify
mv target/release/spotify_player $HOME/.local/bin/spotify_player
chmod +x $HOME/.local/bin/spotify_player

# Papirus Icon Theme
wget -qO- https://git.io/papirus-icon-theme-install | sh
wget -qO- https://git.io/papirus-folders-install | sh