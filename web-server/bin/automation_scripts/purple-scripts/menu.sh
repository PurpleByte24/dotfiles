#!/bin/bash
set -e
source "$(dirname "$0")/lib.sh"

while true; do
  clear
  menu_title "Purple"

  menu_item "1)" "Edit"
  menu_item "2)" "Update"
  menu_item "3)" "Status"
  menu_item "4)" "Reload"
  menu_sep
  menu_item "q)" "Quit"

  menu_hint
  read -r -n1 choice
  echo

  case "$choice" in
    1) purple edit ;;
    2) purple update ;;
    3) purple status ;;
    4) purple reload ;;
    q) exit 0 ;;
  esac
done
