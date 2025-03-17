## Initialisation

```bash
# After a minimal Arch install...
cd && git clone --recurse-submodules https://github.com/masroof-maindak/.dotfiles
cd .dotfiles
chmod +x bootstrap.sh
./bootstrap.sh
```

## Other

### Git SSH Signing

- Git config attempts to use `~/.ssh/id_ed25519.pub` as signing key
- Copy over previous/create new Git signing key

### Source

- Source `utils.sh` and run relevant functions for whatever is required.
- Miscellaneous utilities for river: [flow](https://github.com/stefur/flow) & [river-bedload](https://git.sr.ht/~novakane/river-bedload).

### Obsidian

- Start `Syncthing` and set it up to sync the `~/Documents/Vault` directory with my phone.

### spotify-player

- Generate client ID and write to `~/.cache/spotify_client_id`.

### GTK Theme

- [Bluecurve](https://www.gnome-look.org/p/2191581/) or [Human](https://www.gnome-look.org/p/1313387/)