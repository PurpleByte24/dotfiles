# ------------------------------------------------------------
# Locale / editor
# ------------------------------------------------------------
export LANG=en_US.UTF-8
export EDITOR=vim
export VISUAL=vim

# ------------------------------------------------------------
# custom scripts
# ------------------------------------------------------------
export PATH="$HOME/bin/automation_scripts:$PATH"

# ------------------------------------------------------------
# User Zsh config (XDG-compliant)
# Aliases, functions, env overrides
# ------------------------------------------------------------
if [ -d "$HOME/.config/zsh" ]; then
  for f in "$HOME/.config/zsh"/*.zsh; do
    [ -r "$f" ] && source "$f"
  done
fi

# ------------------------------------------------------------
# Oh My Zsh
# ------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# ------------------------------------------------------------
# Plugins (standalone, framework-free)
# ------------------------------------------------------------
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
