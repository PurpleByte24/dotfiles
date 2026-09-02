#!/bin/bash

set -e

BOOTSTRAP_DIR="$(cd "$(dirname "$0")" && pwd)"

"$BOOTSTRAP_DIR/stow.sh"
"$BOOTSTRAP_DIR/install-omz.sh"
"$BOOTSTRAP_DIR/install-zsh-plugins.sh"
"$BOOTSTRAP_DIR/change-shell-perm.sh"

echo "✅ Bootstrap complete. Restart your terminal (or open a new one) to start using zsh."
