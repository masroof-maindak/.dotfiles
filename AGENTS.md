# AGENTS.md

Personal dotfiles for an Arch/Wayland (Niri) machine plus an Ubuntu/Debian
remote profile. Managed with GNU Stow. There is **no test suite, linter, or
CI** — verification is manual.

## Commands

```bash
make stow-all      # symlink everything at repo root into $HOME
make stow-remote   # remote profile: stage remote-manifest paths, then stow
make clean-remote  # unstow remote profile and delete ./remote
./bootstrap.sh     # full Arch setup; MUST run from $HOME/.dotfiles
./remote-setup.sh  # Ubuntu/Debian setup (runs `make stow-remote`)
```

- `stow-all` is `stow --dir=. --target=$HOME .`; run it after adding/moving any
  tracked dotfile.
- `stow-remote` builds a gitignored `remote/` staging dir from
  `system/package-lists/remote-manifest`, symlinking *individual files* (not
  whole dirs) and pre-creating `$HOME` target dirs, then stows that. Manifest
  entries accept a `src:dst` form to stage under a different name — e.g.
  `.config/git/anon-config:.config/git/config` links the credential-free
  `anon-config` as the remote global git config.
- `bootstrap.sh` hard-checks `pwd -P == $HOME/.dotfiles`, removes existing
  `~/.bashrc`/`~/.bash_profile`, `sudo cp`s files from `system/` into `/etc`
  (pacman.conf, getty skip-login, NM wifi backend), and enables services.

## Stow rules (easy to get wrong)

- `.stow-local-ignore` decides what is **not** symlinked: `makefile`, `README*`,
  the `*.sh` setup/utility scripts, `system/`, `remote/`, `.prettierrc`,
  `.git*`. Add any new top-level setup/tooling file here, or Stow will dump a
  symlink into `$HOME`.
- `.config/`, `.local/`, `.fonts/`, `Desktop/`, `Documents/` are stowed so their
  *contents* link into `$HOME`; the dirs themselves (e.g. `~/.config`) must
  already exist and are created by `bootstrap.sh`.
- Generated/local-only files are gitignored — do not commit them:
  `.config/nvim/lazy-lock.json`, `.config/nvim/spell/`,
  `.config/fish/{fish_variables,conf.d/,functions/_autopair_*}`,
  `active.*` theme files, `remote/`.

## Theming (`swamp`)

Every themed app has `swamp-dark` / `swamp-light` variants plus a switch script
under `.local/share/darkman/<app>.sh`; darkman invokes each with `dark`/`light`
and the script writes an `active.*` file (or `sed`s the config) that the app's
main config `include`s — e.g. `.config/niri/active.kdl`,
`.config/fuzzel/active.ini`. `active.*` is gitignored. To port a theme,
`.local/bin/swamp_hexes.sh <file>` maps Gruvbox hex codes to the Swamp palette.

## Editing notes

- Username `maindak` is hardcoded in several places beyond what the README
  lists — `.config/wgetrc`, `.config/pulse/client.conf`,
  `.config/surge/settings.toml`, `system/skip-username.conf`. Run `rg maindak`
  before assuming a path is portable.
- Package lists are plain text read by helpers in `utils.sh`:
  `system/package-lists/package-list.md` (pacman/paru), `rust` (cargo-binstall),
  `python` (uv tool), `remote-manifest` (remote profile paths).
- Neovim bootstraps lazy.nvim from `.config/nvim/lua/bootstrap.lua`; the lock
  file is local-only. Refresh via `.local/bin/update.sh`
  (`nvim --headless "+Lazy! sync" +qa`, also runs `paru`/`rustup`/`cargo`).

## Git & commits

- **NEVER push, EVER.** No `git push`, force-push, or PR creation — not even
  when asked to "commit", and not with confirmation. The user pushes.
- **Ask before committing.** Before any `git commit`, ask the user:
  - what should go into the commit (propose the files/hunks), and
  - whether to make one commit or split it into several (propose a split when
    changes touch unrelated tools/areas),

  with a draft message for each, then wait for an answer. Leave unrelated
  dirty files alone.
- Style: Conventional Commits, terse, mostly lowercase, no trailing period —
  `type(scope): subject`.
  - Types, by frequency: `chore` (config tweaks, cleanup, removals), `feat`
    (new tool/feature/theme), `patch` (non-standard: small improvements or
    fixes to an existing feature), `fix` (something broken), `docs`,
    `refactor`.
  - Scope is the tool/area (`fish`, `nvim`, `quickshell`, `niri`, `darkman`,
    `remote-setup`); may be omitted (`feat: ...`), comma-joined
    (`niri,update.sh`), or path-like (`bin/git`, `quickshell/media`).
  - Subjects are short, imperative or noun phrases, often joining items with
    `+` or using `w/` (`feat(mpv): modernx + thumbfast + sponsorblock`,
    `patch(fish/keybinds): bat preview w/ fzf on alt+o`). Theme commits read
    like `feat(bat): swamp light/dark`.
  - Bodies are rare; add one only to explain a non-obvious _why_.
  - Prefer one commit per tool/area over large mixed commits.

## Formatting

- Markdown is formatted per `.prettierrc`: 80-col, `proseWrap: always`,
  2-space indent.
