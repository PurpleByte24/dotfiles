# Enable Powerlevel10k instant prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
# Oh-My-Zsh
# ------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"

# Note: Ensure p10k is cloned to $ZSH/custom/themes/powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"
CASE_SENSITIVE="true"

# Only keep built-in OMZ plugins here to avoid "not found" errors
plugins=(git)

source "$ZSH/oh-my-zsh.sh"

# ------------------------------------------------------------
# Plugins & Theme Config
# ------------------------------------------------------------
# Load system plugins (Fixes your inline suggestions)
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Fixes the "new line" menu problem (Ensure fzf-tab is cloned to custom/plugins)
[[ -f ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab/fzf-tab.zsh ]] && \
    source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab/fzf-tab.zsh

# Enable the menu selection highlight
zstyle ':completion:*' menu select

# ------------------------------------------------------------
# Locale / User Config
# ------------------------------------------------------------
export LANG=en_US.UTF-8
export EDITOR=vim
export VISUAL=vim

if [ -d "$HOME/.config/zsh" ]; then
  for f in "$HOME/.config/zsh"/*.zsh; do
    [ -r "$f" ] && source "$f"
  done
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
