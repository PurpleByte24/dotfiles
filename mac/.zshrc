# ------------------------------------------------------------
# Powerlevel10k Instant Prompt (Must be at the very top)
# ------------------------------------------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# ------------------------------------------------------------
# Base Environment & XDG Base Paths
# ------------------------------------------------------------
export LANG=en_US.UTF-8
export EDITOR=nvim
export VISUAL=nvim

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

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
# System & Application XDG Environment Variables
# ------------------------------------------------------------
# Kubernetes & Docker
export KUBECONFIG="$HOME/.config/kube/config"
export DOCKER_CONFIG="$HOME/.config/docker"

# AWS CLI
export AWS_CONFIG_FILE="$HOME/.config/aws/config"
export AWS_SHARED_CREDENTIALS_FILE="$HOME/.config/aws/credentials"

# AI Tools
export CLAUDE_CONFIG_DIR="$HOME/.config/claude"
[ -e "$HOME/.claude" ] || ln -s "$HOME/.config/claude" "$HOME/.claude"
export GEMINI_CONFIG_DIR="$HOME/.config/gemini"
export OLLAMA_MODELS="$XDG_DATA_HOME/ollama/models"

# Python
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"

# ------------------------------------------------------------
# Executable PATH Configuration
# ------------------------------------------------------------
export PATH="$HOME/bin:$HOME/bin/automation_scripts:$PATH"

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
# Development Toolchains
# ------------------------------------------------------------

# Go
export GOPATH="$XDG_DATA_HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Krew (kubectl Plugin Manager)
export KREW_ROOT="$HOME/.config/krew"
export PATH="$KREW_ROOT/bin:$PATH"

# NVM
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# PNPM
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Rust / Cargo
export CARGO_HOME="$HOME/.config/rust/cargo"
export RUSTUP_HOME="$HOME/.config/rust/rustup"
[ -s "$CARGO_HOME/env" ] && . "$CARGO_HOME/env"

# Pipx
export PATH="$PATH:$HOME/.local/bin"

# ------------------------------------------------------------
# Homebrew Initialization (Keep at the end)
# ------------------------------------------------------------
eval "$(/opt/homebrew/bin/brew shellenv)"
