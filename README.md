# Dotfiles

GNU Stow-managed dotfiles for an Arch-Wayland box running Niri and other TUI-focused paraphernalia.

## Initialisation

```bash
# After a 'minimal' `archinstall`...
cd && git clone --recurse-submodules https://github.com/masroof-maindak/.dotfiles
cd .dotfiles
chmod +x bootstrap.sh
./bootstrap.sh
```

## Other

### Update Remote

```bash
cd ~/.dotfiles
git remote set-url origin git@github.com:masroof-maindak/.dotfiles.git
```

### Git SSH Signing

- Git config attempts to use `~/.ssh/id_ed25519.pub` as signing key
- Copy over previous/create new Git signing key

### Source

- Source `utils.sh` and run relevant functions for whatever is required.

### Obsidian

- Start `Syncthing` and set it up to sync the `~/Documents/Vault` directory with my phone.

### spotify-player

- Generate client ID and write to `~/.cache/spotify_client_id`.
- Follow instructions to authenticate.
