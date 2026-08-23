# Sources every *.zsh file in a directory, sorted by filename. Used by
# .zshrc to load pre-Oh-My-Zsh setup and post-Oh-My-Zsh modules (aliases,
# functions, shell behavior) from the common + OS-specific .config/zsh
# trees that stow merges together.
source_zsh_dir() {
    local dir="$1" f
    [ -d "$dir" ] || return 0
    for f in "$dir"/*.zsh(N); do
        [ -r "$f" ] && source "$f"
    done
}
