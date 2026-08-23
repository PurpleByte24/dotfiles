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
export npm_config_cache="$XDG_CACHE_HOME/npm"

# Homebrew services per-formula env overrides (brew services restart reads this)
export HOMEBREW_USER_CONFIG_HOME="$XDG_CONFIG_HOME/homebrew"
export HOMEBREW_BUNDLE_FILE_GLOBAL="$HOMEBREW_USER_CONFIG_HOME/.Brewfile"

# Vendor apps with hardcoded home-dir paths (no XDG/env-var support):
# symlink into .config or .cache depending on content, re-create the
# symlink if it ever gets removed.
[ -e "$HOME/.cisco" ] || ln -s "$HOME/.cache/cisco" "$HOME/.cisco"       # UI history logs only
[ -e "$HOME/.vpn" ] || ln -s "$HOME/.config/vpn" "$HOME/.vpn"           # real prefs (default user, cert thumbprint)
[ -e "$HOME/.ollama" ] || ln -s "$HOME/.config/ollama" "$HOME/.ollama"  # identity key; its cache/ subdir is itself symlinked to .cache/ollama
[ -e "$HOME/.config/ollama/cache" ] || ln -s "$HOME/.cache/ollama" "$HOME/.config/ollama/cache"
[ -e "$HOME/.mongodb" ] || ln -s "$HOME/.cache/mongodb" "$HOME/.mongodb"  # Compass logs only
[ -e "$HOME/.docker" ] || ln -s "$HOME/.config/docker" "$HOME/.docker"  # config.json + buildx/scout cache (docker's own convention keeps these together)

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
