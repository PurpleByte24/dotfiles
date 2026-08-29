#!/bin/bash

source "$(dirname "$0")/lib.sh"

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.local/share/oh-my-zsh/custom}"
declare -A PLUGINS=(
  [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions"
  [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
  [fzf-tab]="https://github.com/Aloxaf/fzf-tab"
)
declare -A THEMES=(
  [powerlevel10k]="https://github.com/romkatv/powerlevel10k.git"
)

for name in "${!PLUGINS[@]}"; do
  dest="$ZSH_CUSTOM/plugins/$name"
  if [ -d "$dest/.git" ]; then
    echo "✅ $name already present, skipping"
  else
    echo "🔗 Cloning $name..."
    git clone --depth=1 "${PLUGINS[$name]}" "$dest"
  fi
done

for name in "${!THEMES[@]}"; do
  dest="$ZSH_CUSTOM/themes/$name"
  if [ -d "$dest/.git" ]; then
    echo "✅ $name already present, skipping"
  else
    echo "🔗 Cloning $name..."
    git clone --depth=1 "${THEMES[$name]}" "$dest"
  fi
done
