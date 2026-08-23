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
# Powerlevel10k theme config
# ------------------------------------------------------------
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
