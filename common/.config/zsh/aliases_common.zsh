# My Aliases For Shell Scripts

s_path="$HOME/bin/automation_scripts"

alias restow="$s_path/stow_system"
alias caliases="$s_path/list_all_aliases"
alias GIT_PURPLEBYTE="$s_path/git_set_config"
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
alias f=fd
alias e="eza -lah --no-quotes"
alias et="eza -aT --no-quotes -I '.git|node_modules|.venv|__pycache__|dist'"
alias b="bat --theme='Catppuccin Mocha'"
