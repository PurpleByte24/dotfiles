#!/bin/bash
set -e
source "$(dirname "$0")/lib.sh"

EDITOR_CMD="${EDITOR:-nano}"

while true; do
  clear
  menu_title "Edit config"

  menu_item "1)" "Nginx GRADES config"
  menu_item "2)" "Nginx GRSA config"
  menu_item "3)" "Cloudflared config"
  menu_sep
  menu_item "q)" "Back"

  menu_hint
  read -r -n1 choice
  echo

  case "$choice" in
    1)
      sudo $EDITOR_CMD /etc/nginx/sites-available/grades.conf
      reload_nginx
      ;;
    2)
      sudo $EDITOR_CMD /etc/nginx/sites-available/grsa.conf
      reload_nginx
      ;;
    3)
      sudo $EDITOR_CMD /etc/cloudflared/config.yml
      restart_cloudflared
      ;;
    q) exit 0 ;;
  esac

  pause
done
