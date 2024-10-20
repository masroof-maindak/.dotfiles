### Initialisation

```bash
# After a minimal Arch install...
cd && git clone --recurse-submodules https://github.com/masroof-maindak/.dotfiles
cd .dotfiles
chmod +x bootstrap.sh
./bootstrap.sh
```

### Other Software

***Firefox***

- Sign in, sync bookmarks, open tabs, history and passwords
- Add extensions and configure telemetry settings
- Follow instructions in Firefox User-chrome repository and clone dots

```bash
cd ~/.mozilla/firefox/*.default-release/
git clone https://github.com/masroof-maindak/chrome
```

- Maybe also go through [this repo](https://github.com/SpitFire-666/Firefox-Stuff)

***Source***

- Source `utils.sh` and run relevant functions for whatever is required
- ~~Miscellaneous utilities for river: [flow](https://github.com/stefur/flow) & [river-bedload](https://git.sr.ht/~novakane/river-bedload)~~
- lf: `env CGO_ENABLED=0 go install -ldflags="-s -w" github.com/gokcehan/lf@latest`

***Obsidian***

- Start `Syncthing` and set it up to sync the `~/Documents/Vault` directory with my phone.

***spotify-player***

- Generate client ID and write to `~/.cache/spotify_client_id`

### TODO

- [ ] Fix prompt bug on certain directories
- [ ] `cpupower-gui` -> `cpupower` & remove desktop + package list entry
- [ ] Clipboard manager (w/ Eww?)
