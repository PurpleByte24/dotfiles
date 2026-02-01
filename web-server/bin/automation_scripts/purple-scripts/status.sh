#!/bin/bash
set -e
source "$(dirname "$0")/lib.sh"

while true; do
  clear
  menu_title "Status"

  menu_item "1)" "Nginx"
  menu_item "2)" "Cloudflared"
  menu_item "3)" "PM2"
  menu_item "4)" "Tailscale"
  menu_sep
  menu_item "q)" "Back"

  menu_hint
  read -r -n1 choice
  echo

  clear
  case "$choice" in
    1)
      title "Nginx"
      systemctl status nginx --no-pager
      ;;
    2)
      title "Cloudflared"
      systemctl status cloudflared --no-pager
      ;;
    3)
      title "PM2"
      pm2 status
      ;;
    4)
      title "Tailscale"
      tailscale status
      ;;
    q)
      exit 0
      ;;
  esac

  pause
done
