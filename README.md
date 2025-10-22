# Dotfiles

GNU Stow-managed dotfiles for an Arch-Wayland box running Niri and other TUI-focused paraphernalia.

## Setup

```bash
# After a 'minimal' `archinstall`...
cd && git clone --recurse-submodules https://github.com/masroof-maindak/.dotfiles
cd .dotfiles
chmod +x bootstrap.sh
./bootstrap.sh
```

## After

### Username Hardcoding

> [!caution] I have [configured](system/skip-username.conf) my TTY to automatically enter my
> username in the virtual console when logging in. To prevent being soft-locked from your system,
> either modify the username in that file, or comment out the relevant line from `bootstrap.sh`.

The only other instance of username hardcoding (exluding Git configs & readmes; at least as of the
moment of writing) is for the [wgetrc](.config/wgetrc) that prevents home-cluttering.

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

- Start `syncthing` and set it up to sync the `~/Documents/Vault`, `~/Pictures/Image Transmission'`,
  and `~/Music` directories with my phone.

### spotify-player

- Generate client ID and write to `~/.cache/spotify_client_id`.
- Follow instructions to authenticate.
