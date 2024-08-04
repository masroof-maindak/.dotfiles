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

- Fix xdg-desktop-portal-wlr screensharing
	- possibly stems from the first two lines in the `init` file not working
- Audio not working
- Update lf for Wayland -> image preview
- Find image viewer, or fix invisible imv window?
	- Invisible Wezterm too
- Clipboard manager w/ Eww?
- cpupower-gui -> cpupower & remove desktop + package list entry

- Clean up X11 garbage
- Test
- Automate wlsunset
