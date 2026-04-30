#!/bin/bash

# Dependency check
check_deps() {
  if ! command -v stow &>/dev/null; then
    echo "❌ Error: GNU Stow is not installed."
    exit 1
  fi
}

# Validation: Root check and Git status
validate_env() {
  local current_dir=$(pwd)
  if ! [[ ${current_dir##*/} == "dotfiles" ]]; then
    echo "❌ Please execute script from the project root. Aborting..."
    exit 1
  fi

  if ! git diff --quiet; then
    echo "❌ Uncommitted changes detected. Aborting..."
    exit 1
  fi
}

# Get absolute path to dotfiles root
get_dotfiles_dir() {
  echo "$(cd "$(dirname "$0")/.." && pwd)"
}

# OS Detection
get_os_package() {
  case "$(uname -s)" in
  Darwin) echo "mac" ;;
  Linux) echo "omarchy-mac" ;;
  *) echo "unknown" ;;
  esac
}
