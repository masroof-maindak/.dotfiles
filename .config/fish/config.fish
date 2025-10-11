set -g fish_greeting ""
set -g fish_completion_case_sensitive no

# Source configuration snippets
for conf_file in ~/.config/fish/conf.d/*.fish
    source $conf_file
end
