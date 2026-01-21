# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Load omarchy-zsh configuration
if [[ -d /usr/share/omarchy-zsh/conf.d ]]; then
  for config in /usr/share/omarchy-zsh/conf.d/*.zsh; do
    [[ -f "$config" ]] && source "$config"
  done
fi

# Load omarchy-zsh functions and aliases
if [[ -d /usr/share/omarchy-zsh/functions ]]; then
  for func in /usr/share/omarchy-zsh/functions/*.zsh; do
    [[ -f "$func" ]] && source "$func"
  done
fi

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
# Plugins (standalone, framework-free)
# ------------------------------------------------------------
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

