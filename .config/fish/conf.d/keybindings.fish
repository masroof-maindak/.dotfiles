set -g fish_completion_case_sensitive no

bind alt-s 'commandline -P "sudo "'
bind alt-n nvim
bind alt-z zi
bind alt-l 'set old_tty (stty -g); stty sane; lfcd; stty $old_tty; commandline -f repaint'
bind alt-m make
