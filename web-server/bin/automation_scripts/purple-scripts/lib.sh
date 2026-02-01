#!/bin/bash

# ---------- colors ----------
BOLD="\033[1m"
DIM="\033[2m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
CYAN="\033[36m"
RESET="\033[0m"

# ---------- ui helpers ----------
menu_title() {
  echo -e "${BOLD}${CYAN}══ $1 ═══════════════════════════════${RESET}"
}

menu_item() {
  printf "  ${BOLD}${BLUE}%s${RESET}  %s\n" "$1" "$2"
}

menu_sep() {
  echo -e "${DIM}────────────────────────────────────${RESET}"
}

menu_hint() {
  echo
  echo -e "${DIM}Press a key to select · q to quit${RESET}"
}

title() {
  echo -e "${BOLD}${CYAN}$1${RESET}"
}

step() {
  echo -e "${BLUE}→${RESET} $1"
}

ok() {
  echo -e "${GREEN}✓${RESET} $1"
}

selected() {
  echo -e "${BOLD}${GREEN}▶ Selected:${RESET} $1"
}

pause() {
  sleep 0.6
}

# ---------- service helpers ----------
reload_nginx() {
  title "Nginx"
  sudo systemctl reload nginx
  ok "Nginx reloaded"
}

restart_pm2() {
  title "PM2"
  if pm2 list | grep -q "grsa-backend"; then
    pm2 restart grsa-backend
  else
    pm2 start npm --name grsa-backend -- start --prefix /var/www/grsa-be
  fi

  if pm2 list | grep -q "grades-backend"; then
    pm2 restart grades-backend
  else
    pm2 start npm --name grades-backend -- start --prefix /var/www/grades-be
  fi

  pm2 save
  ok "PM2 apps running"
}

restart_cloudflared() {
  title "Cloudflare"
  sudo systemctl restart cloudflared
  ok "Cloudflared restarted"
}
