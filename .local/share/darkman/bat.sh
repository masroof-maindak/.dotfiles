#!/bin/sh

# bat only auto-detects the theme when its stdout is a TTY, so it falls back to
# Monokai when piped (paru, fzf). `dark`/`light` pick --theme-dark/--theme-light
# from bat's config; a universal var reaches every running fish session.
case "$1" in
dark | light) fish -c "set -Ux BAT_THEME $1" ;;
default) exit 1 ;;
esac
