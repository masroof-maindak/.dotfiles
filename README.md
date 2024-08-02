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
- Follow instructions in Firefox Userchrome repository and clone dots
```bash
cd ~/.mozilla/firefox/*.default-release/
git clone https://github.com/masroof-maindak/chrome
```
- Maybe also go through [this repo](https://github.com/SpitFire-666/Firefox-Stuff)

***Obsidian***

- Start Syncthing and set it up to sync the `~/Documents/Vault` directory with my phone.

### TODO

- Fix Rofi + Electron apps launching in Xwayland
- River config rewrite
- cpupower-gui -> cpupower & remove desktop + package list entry
- Test