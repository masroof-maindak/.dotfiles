abbr --add g "git"
abbr --add gs "git status"
abbr --add gss "git status -s"

abbr --add rd "ripdrag -a -r"
abbr --add v "nvim"
abbr --add p "pacman"
abbr --add py "python"
abbr --add l "lfcd"
abbr --add m "make"
abbr --add dk "docker"

abbr --add uvr "uv run"
abbr --add uvm "uv run manage.py"

abbr --add nmt "nmtui"
abbr --add nmc "nmcli"

# Since `ls` shows a '/' after a directory's name
abbr --add ls "ls -hN --color=auto --group-directories-first"
abbr --add ll "eza --group-directories-first -l"
abbr --add lt "eza --group-directories-first -T -L=2"
abbr --add lti "eza --group-directories-first -T -L=2 --icons=auto"

abbr --add c "clear"
abbr --add clera "clear"
abbr --add q "exit"
abbr --add quit "exit"
abbr --add qquit "exit"
abbr --add md "mkdir -p"

abbr --add pubip "curl ipinfo.io; echo"
abbr --add copy "wl-copy"
abbr --add pkg "pacman -Q | fzf"
abbr --add fnt "fc-list | fzf"
abbr --add bt "upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | awk '{print $2}'"

abbr --add t "tmux"
# https://foo.zone/gemfeed/2025-05-02-terminal-multiplexing-with-tmux-fish-edition.html
abbr --add tl "tmux ls"
abbr --add tk "tmux kill-session -t"
abbr --add ta "tmux-attach"
abbr --add td "tmux-del"
abbr --add tn "tmux-new"
abbr --add ts "tmux-search"
abbr --add foo "tmux-new foo"
abbr --add bar "tmux-new bar"
abbr --add baz "tmux-new baz"
