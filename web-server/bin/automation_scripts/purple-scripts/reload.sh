#!/bin/bash
set -e
source "$(dirname "$0")/lib.sh"

while true; do
  clear
  menu_title "Reload services"

  menu_item "1)" "Reload Nginx"
  menu_item "2)" "Restart Cloudflared"
  menu_item "3)" "Restart PM2"
  menu_sep
  menu_item "q)" "Quit"

  menu_hint
  read -r -n1 choice
  echo

  clear
  case "$choice" in
    1)
      reload_nginx
      ;;
    2)
      restart_cloudflared
      ;;
    3)
      restart_pm2
      ;;
    q)
      exit 0
      ;;
  esac

  pause
done
