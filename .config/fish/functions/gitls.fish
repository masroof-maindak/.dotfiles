function gitls --description="Show all git aliases"
    git config --list | grep ^alias\. | sed 's/^alias\.//g' | column -t -s'='
end
