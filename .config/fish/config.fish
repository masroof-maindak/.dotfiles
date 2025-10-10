set -g fish_greeting ""

# Source configuration snippets
for conf_file in ~/.config/fish/conf.d/*.fish
    source $conf_file
end

# Source functions
for func_file in ~/.config/fish/functions/*.fish
    source $func_file
end
