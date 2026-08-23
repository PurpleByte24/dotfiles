# ------------------------------------------------------------
# Shared module loader (defines source_zsh_dir)
# ------------------------------------------------------------
source "$HOME/.config/zsh/lib/source_dir.zsh"

# ------------------------------------------------------------
# Pre-Oh-My-Zsh setup (instant prompt, fpath, omz config, compdump)
# ------------------------------------------------------------
source_zsh_dir "$HOME/.config/zsh/pre-omz"

source "$ZSH/oh-my-zsh.sh"

# ------------------------------------------------------------
# User Zsh Module Sourcing
# ------------------------------------------------------------
# Load all custom modular configs (aliases, functions, shell behavior)
source_zsh_dir "$HOME/.config/zsh"

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
