# My Aliases For Shell Scripts

s_path="$HOME/bin/automation_scripts"

alias restow="$s_path/stow_system"
alias ls_a="$s_path/list_all_aliases"
alias tt="$s_path/show_file_tree"
alias v='nvim'
alias gs='git status -sb'
alias gl='git pull'
alias gpo='git push origin'
alias gp='git push'
alias ga='git add'
alias gc='git commit -m'
alias l='ls -lAh'
alias vz="nvim $HOME/.zshrc"
alias sz="source $HOME/.zshrc"
alias k='kubectl'
alias g=rg
alias f='fd -H'
alias e="eza -lah --no-quotes --color=always"
alias et="eza -aT --no-quotes --color=always -I '.git|node_modules|.venv|__pycache__|dist|target'"
alias b="bat --theme='Catppuccin Mocha'"
alias watch='watch -c '
