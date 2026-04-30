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

echo "🔗 Stowing packages..."

# Stow common and OS-specific with --adopt
stow -v --adopt --dir="$DOTFILES_DIR" --target="$HOME" --ignore='.DS_Store' common
stow -v --adopt --dir="$DOTFILES_DIR" --target="$HOME" --ignore='.DS_Store' "$OS_PKG"

echo "✅ Symlinks created"

# Restore repo state
git checkout .
echo "✅ File contents restored to remote status"

echo "Run alias 'restow' to restore your system (dont forget to restart shell!!)"
