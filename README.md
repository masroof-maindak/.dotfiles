# Dotfiles

GNU Stow-managed dots for an Arch-Wayland box running Niri, a plethora of
TUI-focused paraphernalia comprising (non-exhaustively) `tmux`, `fish`,
`zoxide`, `fzf`, `lf`, and [`neovim`](https://github.com/masroof-maindak/nvim),
and a grimoire's worth of keybinds coupled w/ a cantankerous Kanata config;
chock-full of arcane runes that render my humble digital-dwelling's QoL
significantly more conducive to effective (and enjoyable) spell-casting.

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
> I have [configured](system/skip-username.conf) my TTY to automatically enter
> my username in the virtual console when logging in. To prevent the egregious
> inconvenience of always failing your first login attempt (unless your username
> is `maindak`), either modify the username in that file, or comment out the
> relevant line from `bootstrap.sh`.

The only other instance of username hardcoding (exluding Git configs & readmes;
at least as of the moment of writing) is for the [wgetrc](.config/wgetrc) that
prevents home-cluttering, but maybe run a `rg maindak` after cloning just to be
safe.

### Update Remote

```bash
cd ~/.dotfiles
git remote set-url origin git@github.com:masroof-maindak/.dotfiles.git
```

### Git SSH Signing

- Git config attempts to use `~/.ssh/id_ed25519.pub` as signing key
- Copy over previous/create new Git signing key

### Build From Source

- A couple of helper functions have been provided in `utils.sh`; source it and
  run what you deem fit
- [`eww-niri-workspaces`](https://github.com/druskus21/eww-niri-workspaces) --
  required for the workspace indicator in my
  [Eww](https://github.com/elkowar/eww) bar
- ???

### Obsidian

- Start `syncthing` and set it up to sync the `~/Documents/Vault`,
  `~/Pictures/Image Transmission`, and `~/Music` directories with my phone.

### spotify-player

- Generate client ID and write to `~/.cache/spotify_client_id`.
- Follow instructions to authenticate.

### Kanata

- Follow the instructions in their [setup
  guide](https://github.com/jtroo/kanata/blob/main/docs/setup-linux.md).
- Whilst copying over the sample SystemD service, ensure the `Environment`
  variable under the `[Service]` heading contains the path of the `kanata`
  installation; this should be `/home/<user>/.local/share/cargo/bin`
