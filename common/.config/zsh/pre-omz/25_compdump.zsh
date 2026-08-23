# Relocate the compinit dump file to $XDG_CACHE_HOME. Must be set
# before $ZSH/oh-my-zsh.sh runs compinit.
ZSH_COMPDUMP_DIR="$XDG_CACHE_HOME/zsh"
mkdir -p "$ZSH_COMPDUMP_DIR"
export ZSH_COMPDUMP="$ZSH_COMPDUMP_DIR/zcompdump"
