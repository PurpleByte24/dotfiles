# ------------------------------------------------------------
# Sourced by EVERY zsh invocation — login, interactive, and
# non-interactive (scripts, tool calls, cron, git hooks, ssh
# commands). Keep this to plain env vars / PATH only.
#
# Anything interactive (prompt theme, plugins, completions,
# aliases, slow activation scripts like nvm/rustup) belongs in
# ~/.zshrc instead, which non-interactive shells never read.
# ------------------------------------------------------------

# Base Environment
export LANG=en_US.UTF-8
export EDITOR=nvim
export VISUAL=nvim

# XDG Base Paths
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

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

# Development Toolchain directories (activation scripts stay in .zshrc)
export GOPATH="$XDG_DATA_HOME/go"
export KREW_ROOT="$HOME/.config/krew"
export NVM_DIR="$HOME/.config/nvm"
export PNPM_HOME="$HOME/Library/pnpm"
export CARGO_HOME="$HOME/.config/rust/cargo"
export RUSTUP_HOME="$HOME/.config/rust/rustup"

# ------------------------------------------------------------
# Executable PATH
# ------------------------------------------------------------
export PATH="$HOME/bin:$HOME/bin/automation_scripts:$PATH"
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
