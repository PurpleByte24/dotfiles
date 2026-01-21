# ------------------------------------------------------------
# Powerlevel10k instant prompt (must be at the very top)
# ------------------------------------------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# ------------------------------------------------------------
# Oh-My-Zsh
# ------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
CASE_SENSITIVE="true"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

# ------------------------------------------------------------
# PATH (single authoritative block)
# ------------------------------------------------------------
export PATH="/opt/homebrew/bin:$HOME/bin:$HOME/bin/automation_scripts:$PATH"

# ------------------------------------------------------------
# Locale / editor
# ------------------------------------------------------------
export LANG=en_US.UTF-8
export EDITOR=vim
export VISUAL=vim

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
# Powerlevel10k theme config
# ------------------------------------------------------------
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# ------------------------------------------------------------
# Toolchains
# ------------------------------------------------------------

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# ------------------------------------------------------------
# Terminal-specific extras
# ------------------------------------------------------------

# iTerm2 shell integration
[ -e "$HOME/.iterm2_shell_integration.zsh" ] && source "$HOME/.iterm2_shell_integration.zsh"

