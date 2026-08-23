# Custom completion scripts. Must be added to fpath before Oh-My-Zsh
# runs compinit.
if [ -d "$HOME/.config/zsh/completions" ]; then
    fpath=("$HOME/.config/zsh/completions" $fpath)
fi
