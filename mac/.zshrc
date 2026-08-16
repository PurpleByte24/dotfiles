# ------------------------------------------------------------
# Powerlevel10k Instant Prompt (Must be at the very top)
# ------------------------------------------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# ------------------------------------------------------------
# Custom Completions Lookup
# ------------------------------------------------------------
if [ -d "$HOME/.config/zsh/completions" ]; then
    fpath=("$HOME/.config/zsh/completions" $fpath)
fi

# ------------------------------------------------------------
# Oh-My-Zsh Configuration
# ------------------------------------------------------------
export ZSH="$XDG_DATA_HOME/oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
CASE_SENSITIVE="true"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    fzf-tab
)

# Relocate zcompdump cache to ~/.cache/zsh/
ZSH_COMPDUMP_DIR="$XDG_CACHE_HOME/zsh"
mkdir -p "$ZSH_COMPDUMP_DIR"
export ZSH_COMPDUMP="$ZSH_COMPDUMP_DIR/zcompdump"

source "$ZSH/oh-my-zsh.sh"

# ------------------------------------------------------------
# Completion & Shell Customizations
# ------------------------------------------------------------
# Show dotfiles in completion menus
setopt globdots
zstyle ':completion:*' special-dirs false
zstyle ':completion:*' search-path-options --hidden --follow
export FZF_COMPLETION_OPTS="--style=full"

DISABLE_AUTO_TITLE=true

# ------------------------------------------------------------
# User Zsh Module Sourcing
# ------------------------------------------------------------
# Load all custom modular configs (aliases, functions, env overrides)
if [ -d "$HOME/.config/zsh" ]; then
    for f in "$HOME/.config/zsh"/*.zsh; do
        [ -r "$f" ] && source "$f"
    done
fi

# ------------------------------------------------------------
# Powerlevel10k Theme
# ------------------------------------------------------------
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ -f "$HOME/.config/zsh/p10k.zsh" ]] && source "$HOME/.config/zsh/p10k.zsh"

# ------------------------------------------------------------
# Terminal Extensions
# ------------------------------------------------------------
# iTerm2 Shell Integration
[ -f "$HOME/.config/zsh/iterm2_shell_integration.zsh" ] && source "$HOME/.config/zsh/iterm2_shell_integration.zsh"

# ------------------------------------------------------------
# Development Toolchain Activation
# ------------------------------------------------------------

# NVM
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Rust / Cargo
[ -s "$CARGO_HOME/env" ] && . "$CARGO_HOME/env"

# ------------------------------------------------------------
# Homebrew Initialization (Keep at the end)
# ------------------------------------------------------------
eval "$(/opt/homebrew/bin/brew shellenv)"
