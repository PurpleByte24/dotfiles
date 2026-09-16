# ------------------------------------------------------------
# Sourced by EVERY zsh invocation — see env_common.zsh for the
# full explanation and the vars shared with other OSes.
# ------------------------------------------------------------
source "$HOME/.config/zsh/env_common.zsh"

# ------------------------------------------------------------
# Mac-specific env
# ------------------------------------------------------------

# Kubernetes & Docker
export KUBECONFIG="$HOME/.config/kube/config"
export DOCKER_CONFIG="$HOME/.config/docker"

# AWS CLI
export AWS_CONFIG_FILE="$HOME/.config/aws/config"
export AWS_SHARED_CREDENTIALS_FILE="$HOME/.config/aws/credentials"

# AI Tools
export GEMINI_CONFIG_DIR="$HOME/.config/gemini"
export OLLAMA_MODELS="$XDG_DATA_HOME/ollama/models"
export npm_config_cache="$XDG_CACHE_HOME/npm"

# Homebrew services per-formula env overrides (brew services restart reads this)
export HOMEBREW_USER_CONFIG_HOME="$XDG_CONFIG_HOME/homebrew"
export HOMEBREW_BUNDLE_FILE="$HOMEBREW_USER_CONFIG_HOME/Brewfile"

# Python
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"

# Java
export JAVA_HOME=$(/usr/libexec/java_home)

# Development Toolchain directories (activation scripts stay in .zshrc)
export GOPATH="$XDG_DATA_HOME/go"
export KREW_ROOT="$HOME/.config/krew"
export NVM_DIR="$HOME/.config/nvm"
export PNPM_HOME="$HOME/Library/pnpm"
export CARGO_HOME="$HOME/.config/rust/cargo"
export RUSTUP_HOME="$HOME/.config/rust/rustup"

# ------------------------------------------------------------
# Executable PATH (additions on top of env_common.zsh's base)
# ------------------------------------------------------------
export PATH="$GOPATH/bin:$PATH"
export PATH="$KREW_ROOT/bin:$PATH"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
export PATH="$PATH:$HOME/.local/bin"

# Homebrew: cheap PATH-only prepend, no subprocess. Full env
# (MANPATH/INFOPATH/etc via `brew shellenv`) is set in .zshrc
# since running the brew binary on every non-interactive shell
# would be slow.
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
