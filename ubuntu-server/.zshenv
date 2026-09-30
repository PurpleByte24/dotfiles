# ------------------------------------------------------------
# Sourced by EVERY zsh invocation — see env_common.zsh for the
# full explanation and the vars shared with other OSes.
# ------------------------------------------------------------
source "$HOME/.config/zsh/env_common.zsh"

# ------------------------------------------------------------
# Ubuntu-server-specific env
# ------------------------------------------------------------

# Kubernetes / homelab
export KUBECONFIG="$HOME/.kube/config"

# ------------------------------------------------------------
# Executable PATH (additions on top of env_common.zsh's base)
# ------------------------------------------------------------
# Debian's /etc/zsh/zshenv sets PATH without the sbin dirs (Ubuntu
# gets them from /etc/environment), so add them explicitly.
# typeset -U dedupes entries re-added by nested shells.
typeset -U path PATH
path+=(/usr/local/sbin /usr/sbin /sbin)
