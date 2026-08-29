# ------------------------------------------------------------
# Env vars shared by every OS. Sourced from each OS's .zshenv,
# which is itself read by EVERY zsh invocation — login,
# interactive, and non-interactive (scripts, tool calls, cron,
# git hooks, ssh commands). Keep this to plain env vars / PATH
# only.
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

# ------------------------------------------------------------
# Executable PATH (base — OS-specific .zshenv files may prepend
# further entries after sourcing this file)
# ------------------------------------------------------------
export PATH="$HOME/bin:$HOME/bin/automation_scripts:$PATH"
