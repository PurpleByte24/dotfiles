# Completion & shell behavior. Safe to set after Oh-My-Zsh/compinit.
setopt globdots
zstyle ':completion:*' special-dirs false
zstyle ':completion:*' search-path-options --hidden --follow
export FZF_COMPLETION_OPTS="--style=full"

DISABLE_AUTO_TITLE=true
