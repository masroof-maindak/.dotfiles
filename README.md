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
ssh-keygen -t ed25519 -C "<email@example.com>" -f $HOME/.ssh/id_ed25519 -N "<passphrase - empty possible>"
eval "$(ssh-agent -s)"
ssh-add $HOME/.ssh/id_ed25519
cat $HOME/.ssh/id_ed25519.pub > $HOME/ssh-pub-key

git config --global user.name "masroof-maindak"
git config --global user.email "<email-to-commit-from>"
```

### Other Software

***Vencord***: `sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"`

***Firefox***:
- Configure flags in `about:config` from the GUI
    - _toolkit.legacyUserProfileCustomizations.stylesheets_ => true
- Get dots from repository
```bash
cd ~/.mozilla/firefox/*.default-release/
git clone https://github.com/masroof-maindak/chrome
```
- Maybe also go through [this repo](https://github.com/SpitFire-666/Firefox-Stuff)

### TODO:

- [ ] Obsidian - Swamp Light Port
- [ ] Discord - Swamp Light
- [ ] Test Bootstrap.sh
- [ ] Firefox dots -> init repo `masroof-maindak/chrome`
- [ ] Delete this repo and start clean
