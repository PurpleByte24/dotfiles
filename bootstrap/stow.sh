#!/bin/bash

OS=$(uname -s)
DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# Always stow common
stow -v --dir="$DOTFILES_DIR" --target="$HOME" --ignore='.DS_Store' common

# Stow OS-specific
case "$OS" in
  Darwin)
    stow -v --dir="$DOTFILES_DIR" --target="$HOME" --ignore='.DS_Store' mac
    ;;
  Linux)
    stow --dir="$DOTFILES_DIR" --target="$HOME" --ignore='.DS_Store' omarchy
    ;;
  *)
    echo "Unknown OS: $OS"
    exit 1
    ;;
esac

echo "✅ Stowed successfully"

echo "Run alias 'restow' to restore you system (dont forget to restart shell!!)"
