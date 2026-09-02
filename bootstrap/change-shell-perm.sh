#!/bin/bash

source "$(dirname "$0")/lib.sh"

ZSH_BIN="/bin/zsh"

if ! grep -qx "$ZSH_BIN" /etc/shells; then
  echo "❌ $ZSH_BIN not listed in /etc/shells. Aborting..."
  exit 1
fi

if [[ "$SHELL" == "$ZSH_BIN" ]]; then
  echo "✅ Login shell already zsh, skipping"
else
  echo "🔗 Changing login shell to $ZSH_BIN (you may be prompted for your password)..."
  chsh -s "$ZSH_BIN"
  echo "✅ Login shell changed to $ZSH_BIN (restart your terminal to take effect)"
fi
