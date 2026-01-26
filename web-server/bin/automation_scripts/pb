#!/bin/bash
set -e

# Automatically resolve the home directory
SCRIPT_DIR="$HOME/bin/automation_scripts/pb-scripts"

usage() {
  echo "Usage: pb [option]"
  echo "  -u   run update script (menus)"
  echo "  -e   run config editor script (to be created)"
  exit 1
}

if [ $# -ne 1 ]; then
  usage
fi

case "$1" in
  -u)
    "$SCRIPT_DIR/pb_update.sh"
    ;;
  -e)
    "$SCRIPT_DIR/pb_edit.sh"
    ;;
  *)
    usage
    ;;
esac
