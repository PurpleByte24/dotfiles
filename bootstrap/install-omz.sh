#!/bin/bash

source "$(dirname "$0")/lib.sh"

OMZ_DIR="$HOME/.local/share/oh-my-zsh"

if [ -d "$OMZ_DIR/.git" ]; then
  echo "✅ Oh My Zsh already present, skipping"
else
  echo "🔗 Cloning Oh My Zsh..."
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$OMZ_DIR"
fi
