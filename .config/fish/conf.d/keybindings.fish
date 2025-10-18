bind alt-n nvim
bind alt-z 'zi && commandline --function repaint'
bind alt-l 'set old_tty (stty -g); stty sane; lfcd; stty $old_tty; commandline -f repaint'
bind alt-m make
