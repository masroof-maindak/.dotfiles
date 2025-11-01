set -g fish_greeting ""
set -g fish_completion_case_sensitive no

for f in ~/.config/fish/user-conf/*.fish; source $f; end
