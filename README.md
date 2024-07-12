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
ssh-keygen -t ed25519 -C "<email@example.com>" -f $HOME/.ssh/id_ed25519 -N "<passphrase - empty possible>"
eval "$(ssh-agent -s)"
ssh-add $HOME/.ssh/id_ed25519
cat $HOME/.ssh/id_ed25519.pub > $HOME/ssh-pub-key

git config --global user.name "masroof-maindak"
git config --global user.email "<email-to-commit-from>"
```

#### TODO:

- [ ] Alacritty - Swamp Ports
- [ ] foot - Swamp ports
- [ ] Heroic + Dunst - Swamp Light
- [ ] Bootstrap.sh - Papirus folders
- [ ] Swamp Light - Phocus + Discord
- [ ] Test Bootstrap.sh
- [ ] Better way to install GTK theme?
- [ ] Can we stow system files directly to /usr/... ?
- [ ] Delete this repo and clean start
