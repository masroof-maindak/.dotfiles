bind alt-c 'cliphist-fzf-sixel'
bind alt-f 'fiv'
bind alt-j 'jrnl'
bind alt-l 'set old_tty (stty -g); stty sane; lfcd; stty $old_tty; commandline -f repaint'
bind alt-m 'make; commandline -f repaint'
bind alt-o "set -l f ($_fd . -t f -H --exclude '.git/**' | fzf --preview 'bat --theme="swamp-$(darkman get)" -P -p --color=always {} --line-range=:250') && \$EDITOR \$f"
bind alt-t 'tmux-new; commandline -f repaint'
bind alt-z 'zi; commandline -f repaint'
