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

### Other Software

***Vencord***: `sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"`

#### TODO:

- [ ] Obsidian - Swamp Light Port
- [ ] Dunst - Swamp Light
- [ ] Phocus - Swamp Light
- [ ] Discord - Swamp Light
- [ ] Test Bootstrap.sh
- [ ] Better way to install GTK theme - place in .themes instead
- [ ] New repo for Firefox dots
- [ ] Can we stow system files directly to /usr/... ?
- [ ] Delete this repo and clean start
