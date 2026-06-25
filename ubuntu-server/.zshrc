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
  fzf-tab
)

source "$ZSH/oh-my-zsh.sh"

# ------------------------------------------------------------
# PATH (single authoritative block)
# ------------------------------------------------------------
export PATH="$HOME/bin:$HOME/bin/automation_scripts:$PATH"

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
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# ------------------------------------------------------------
# Kubernetes / homelab
# ------------------------------------------------------------
export KUBECONFIG=~/.kube/config

# ------------------------------------------------------------
# Shell behavior
# ------------------------------------------------------------
DISABLE_AUTO_TITLE=true
