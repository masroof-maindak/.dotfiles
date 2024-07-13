### Init

To get started following a minimal Arch installation:

```bash
git clone https://github.com/masroof-maindak/dotfiles ~/.dotfiles/
cd .dotfiles || exit
chmod +x bootstrap.sh
./bootstrap.sh
```

### Obsidian

Then, I'll want to get my Obsidian Vault. Start Syncthing and set it up to sync the `~/Documents/Vault` directory with my phone.

### SSH

```bash
ssh-keygen -t ed25519 -C "<email>" -f $HOME/.ssh/id_ed25519 -N "<password>"
eval "$(ssh-agent -s)"
ssh-add $HOME/.ssh/id_ed25519
cat $HOME/.ssh/id_ed25519.pub > $HOME/ssh-pub-key

git config --global user.name "masroof-maindak"
git config --global user.email "<email>"
```

### Other Software

***Firefox***:
- Configure flags in `about:config` from the GUI
    - _toolkit.legacyUserProfileCustomizations.stylesheets_ => _true_
- Get dots from repository
```bash
cd ~/.mozilla/firefox/*.default-release/
git clone https://github.com/masroof-maindak/chrome
```
- Maybe also go through [this repo](https://github.com/SpitFire-666/Firefox-Stuff)

### TODO:

- [ ] Firefox - unhide URL bar search suggestions
- [ ] Obsidian - Swamp Light 'Dark Hard' -> second background & text marked with `like so.`
- [ ] Lutgen - PR Swamp Light
- [ ] Test Bootstrap.sh
- [ ] Delete this repo and start clean
