#!/bin/bash

source "$(dirname "$0")/lib.sh"

check_deps
validate_env

DOTFILES_DIR=$(get_dotfiles_dir)
OS_PKG=$(get_os_package)

if [[ "$OS_PKG" == "unknown" ]]; then
  echo "❌ Unknown OS. Aborting..."
  exit 1
fi

echo "🔓 Unstowing packages..."

# -D flag deletes the symlinks from the target
stow -v -D --dir="$DOTFILES_DIR" --target="$HOME" common
stow -v -D --dir="$DOTFILES_DIR" --target="$HOME" "$OS_PKG"

echo "✅ Symlinks removed. Your config files are no longer linked to this repo."
