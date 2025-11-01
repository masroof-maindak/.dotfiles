# Dotfiles

GNU Stow-managed dotfiles for an Arch-Wayland box running Niri and other TUI-focused paraphernalia
comprising `tmux`, `fish`, `zoxide`, `fzf`, `lf`, and
[`neovim`](https://github.com/masroof-maindak/nvim), amidst others; chock-full of tiny little
tidbits that make my QoL in the shell ~~ever-so-slightly~~ significantly better.

## Setup

```bash
# Following a 'minimal' `archinstall`:
cd && git clone https://github.com/masroof-maindak/.dotfiles
cd .dotfiles
chmod +x bootstrap.sh
./bootstrap.sh
```

## After

### Username Hardcoding

> [!CAUTION]
>
> I have [configured](system/skip-username.conf) my TTY to automatically enter my username in the
> virtual console when logging in. To prevent being soft-locked from your system, either modify the
> username in that file, or comment out the relevant line from `bootstrap.sh`.

The only other instance of username hardcoding (exluding Git configs & readmes; at least as of the
moment of writing) is for the [wgetrc](.config/wgetrc) that prevents home-cluttering.

### Update Remote

```bash
cd ~/.dotfiles
git remote set-url origin git@github.com:masroof-maindak/.dotfiles.git
```

### Git SSH Signing

- Git config attempts to use `~/.ssh/id_ed25519.pub` as signing key
- Copy over previous/create new Git signing key

### Neovim

```bash
git clone git@github.com:masroof-maindak/nvim.git ~/.config/nvim
nvim
```

### Source

- Source `utils.sh` and run relevant functions for whatever is required.

### Obsidian

- Start `syncthing` and set it up to sync the `~/Documents/Vault`, `~/Pictures/Image Transmission`,
  and `~/Music` directories with my phone.

### spotify-player

- Generate client ID and write to `~/.cache/spotify_client_id`.
- Follow instructions to authenticate.

### Kanata

- Follow the instructions in their [setup guide](https://github.com/jtroo/kanata/blob/main/docs/setup-linux.md).
