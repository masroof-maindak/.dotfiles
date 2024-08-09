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

***Obsidian***

- Start `Syncthing` and set it up to sync the `~/Documents/Vault` directory with my phone.

### TODO

- [ ] lf: fix statfmt
- [ ] Fix `xdg-desktop-portal-wlr` screen-sharing - first two lines in river's `init`
- [ ] Clipboard manager w/ Eww?
- [ ] `cpupower-gui` -> `cpupower` & remove desktop + package list entry
- [ ] Test bootstrap.sh
- [ ] Automate `wlsunset`
- [ ] Better bar
