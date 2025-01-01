## Initialisation

```bash
# After a minimal Arch install...
cd && git clone --recurse-submodules https://github.com/masroof-maindak/.dotfiles
cd .dotfiles
chmod +x bootstrap.sh
./bootstrap.sh
```

## Other

***Git SSH Signing***

- Git config attempts to use `~/.ssh/id_ed25519.pub` as signing key
- Copy over previous/create new Git signing key

***Firefox***

- Sign in, sync bookmarks, open tabs, history and passwords
- Add extensions and configure telemetry settings
- Follow instructions in Firefox [User-chrome](https://github.com/masroof-maindak/chrome) repository and clone dots

```bash
cd ~/.mozilla/firefox/*.default-release/
git clone git@github.com:masroof-maindak/chrome.git
```

- Maybe also go through [this repo](https://github.com/SpitFire-666/Firefox-Stuff).

***Source***

- Source `utils.sh` and run relevant functions for whatever is required.
- Miscellaneous utilities for river: [flow](https://github.com/stefur/flow) & [river-bedload](https://git.sr.ht/~novakane/river-bedload).

***Obsidian***

- Start `Syncthing` and set it up to sync the `~/Documents/Vault` directory with my phone.

***spotify-player***

- Generate client ID and write to `~/.cache/spotify_client_id`.
