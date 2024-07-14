### Init

To get started following a minimal Arch installation:

```bash
git clone https://github.com/masroof-maindak/dotfiles ~/.dotfiles/
cd .dotfiles
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

***Firefox***
- Sign in, sync bookmarks, open tabs, history and passwords
- Add extensions and configure telemetry settings
- Follow instructions in Firefox Userchrome repository and clone dots
```bash
cd ~/.mozilla/firefox/*.default-release/
git clone https://github.com/masroof-maindak/chrome
```
- Maybe also go through [this repo](https://github.com/SpitFire-666/Firefox-Stuff)

### TODO:

- [ ] Lutgen - PR Swamp Light
- [ ] Test Bootstrap.sh
- [ ] Delete this repo and start clean
