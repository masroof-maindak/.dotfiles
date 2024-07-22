### Initialisation

```bash
# After a minimal Arch install...
git clone --recurse-submodules https://github.com/masroof-maindak/dotfiles ~/.dotfiles/
cd ~/.dotfiles
chmod +x bootstrap.sh
./bootstrap.sh
```

### SSH Setup

```bash
# NOTE: Safe way to sync these from a backup?
ssh-keygen -t ed25519 -C "<email>" -f $HOME/.ssh/id_ed25519 -N "<password>"
eval "$(ssh-agent -s)"
ssh-add $HOME/.ssh/id_ed25519
cat $HOME/.ssh/id_ed25519.pub > $HOME/ssh-pub-key

# TODO: Move this to bootstrap.sh
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

***Obsidian***

- Start Syncthing and set it up to sync the `~/Documents/Vault` directory with my phone.

