# ------------------------------------------------------------
# Sourced by EVERY zsh invocation — login, interactive, and
# non-interactive (scripts, tool calls, cron, git hooks, ssh
# commands). Keep this to plain env vars / PATH only.
#
# Anything interactive (prompt theme, plugins, completions,
# aliases) belongs in ~/.zshrc instead, which non-interactive
# shells never read.
# ------------------------------------------------------------

# Base Environment
export LANG=en_US.UTF-8
export EDITOR=nvim
export VISUAL=nvim

# XDG Base Paths
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Kubernetes / homelab
export KUBECONFIG="$HOME/.kube/config"

# ------------------------------------------------------------
# Executable PATH
# ------------------------------------------------------------
export PATH="$HOME/bin:$HOME/bin/automation_scripts:$PATH"
