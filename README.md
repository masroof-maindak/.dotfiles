# Dotfiles

![rice](.github/assets/rice.png) ![nvim](.github/assets/nvim.png)

GNU Stow-consecrated talismans for an Arch-Wayland sanctum running Niri, a
plethora of TUI-focused arcana comprising (non-exhaustively) `tmux`, `fish`,
`zoxide`, `fzf`, `lf`, and `neovim`, and a grimoire's worth of keybinds coupled
w/ a cantankerous Kanata config; encrusted with eldritch runes that render mine
digital swamp's mana attunement significantly more conducive to nimble (and
delightfully whimsical) spell-casting.

## Setup

```bash
cd && git clone https://github.com/masroof-maindak/.dotfiles
cd .dotfiles

# Full desktop (following a 'minimal' archinstall)
chmod +x bootstrap.sh
./bootstrap.sh

# Remote/minimal server
make stow-remote
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

### Syncthing

- Start `syncthing` and set it up to sync the `~/Documents/Vault`,
  `~/Pictures/Image Transmission`, and `~/Music` directories with my phone.

### spotify-player

- Generate client ID and write to `~/.cache/spotify_client_id`.
- Follow instructions to authenticate.

### Kanata

- Follow the instructions in their
  [setup guide](https://github.com/jtroo/kanata/blob/main/docs/setup-linux.md).
- Whilst copying over the sample SystemD service, ensure the `Environment`
  variable under the `[Service]` heading contains the path of the `kanata`
  installation; this should be `/home/<user>/.local/share/cargo/bin`

### Tailscale

```bash
sudo tailscale up
```

# TODO

- [ ] Windows LF config; see:
  - <https://ahrm.github.io/jekyll/update/2022/04/02/using-lf-file-manager-on-windows.html>
  - <https://konfekt.github.io/blog/2024/09/15/lf-linux-windows>
- [ ] Nvim: detect TTY, and if true, change to dark theme
- [ ] Nvim: auto search-replace (%s) on word under cursor (e.g selected via
      `viw`)
