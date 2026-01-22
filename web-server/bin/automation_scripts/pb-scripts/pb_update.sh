#!/bin/bash
set -e

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

warn() {
  echo -e "${YELLOW}!${RESET} $1"
}

selected() {
  echo -e "${BOLD}${GREEN}▶ Selected:${RESET} $1"
}

pause() {
  sleep 0.6
}

# ---------- helpers ----------
reload_nginx() {
  title "Nginx"
  step "Reloading nginx"
  sudo systemctl reload nginx
  ok "Nginx reloaded"
}

reload_pm2() {
  title "PM2"
  step "Restarting pm2 processes"
  pm2 restart all
  ok "PM2 restarted"
}

reload_cloudflare() {
  title "Cloudflare"
  step "Restarting cloudflared"
  sudo systemctl restart cloudflared
  ok "Cloudflared restarted"
}

# ---------- GRSA ----------
update_grsa_fe() {
  title "GRSA frontend"

  export NVM_DIR="/home/grsa/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  nvm use default > /dev/null

  REPO="/home/grsa/github/grsa-fe"
  TARGET="/var/www/dev-frontend"

  step "Pulling repository"
  cd "$REPO"
  git pull

  step "Installing dependencies"
  rm -rf node_modules package-lock.json
  npm install
  npm ci

  step "Building frontend"
  npm run build

  step "Deploying to $TARGET"
  rm -rf "$TARGET"/*
  cp -r dist/* "$TARGET"/

  reload_nginx
  ok "GRSA frontend update complete"
}

update_grsa_be() {
  title "GRSA backend"

  export NVM_DIR="/home/grsa/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  nvm use default > /dev/null

  REPO="/home/grsa/github/grsa-be"
  TARGET="/var/www/dev-backend"

  step "Pulling repository"
  cd "$REPO"
  git pull

  step "Installing dependencies"
  npm ci

  step "Building backend"
  npm run build

  step "Deploying to $TARGET"
  rm -rf "$TARGET"/*
  cp package.json package-lock.json .env "$TARGET"/
  cp -r dist "$TARGET"/

  cd "$TARGET"
  npm ci --production

  step "Restarting backend"
  pm2 delete grsa-backend || true
  pm2 start dist/server.js --name grsa-backend --env production

  ok "GRSA backend update complete"
}

# ---------- GRADES ----------
update_grades_fe() {
  title "GRADES frontend"

  REPO="/home/grades/app/grade-compass"
  TARGET="/var/www/grades-fe"

  step "Pulling repository"
  cd "$REPO"
  git pull

  step "Installing dependencies"
  rm -rf node_modules package-lock.json
  npm install
  npm ci

  step "Building frontend"
  npm run build

  step "Deploying to $TARGET"
  rm -rf "$TARGET"/*
  cp -r dist/* "$TARGET"/

  reload_nginx
  ok "GRADES frontend update complete"
}

# ---------- menus ----------
project_menu() {
  clear
  menu_title "Select target"

  menu_item "1)" "Frontend"
  menu_item "2)" "Backend"
  menu_item "3)" "Both"
  menu_sep
  menu_item "q)" "Back"

  menu_hint
  read -r -n1 PROJECT_CHOICE
  echo
}

# ---------- main loop ----------
while true; do
  echo
  menu_title "Update menu"

  menu_item "1)" "Update GRSA frontend / backend"
  menu_item "2)" "Update GRADES frontend"
  menu_sep
  menu_item "3)" "Reload Cloudflare"
  menu_item "4)" "Reload Nginx"
  menu_item "5)" "$(echo -e "${RED}Restart PM2${RESET}")"
  menu_sep
  menu_item "q)" "Quit"

  menu_hint
  read -r -n1 main
  echo

  case "$main" in
    1)
      project_menu
      clear
      selected "GRSA"
      case "$PROJECT_CHOICE" in
        1) update_grsa_fe ;;
        2) update_grsa_be ;;
        3)
          update_grsa_fe
          update_grsa_be
          ;;
      esac
      pause
      ;;
    2)
      project_menu
      clear
      selected "GRADES"
      case "$PROJECT_CHOICE" in
        1) update_grades_fe ;;
        2) warn "Grades has no backend" ;;
        3) update_grades_fe ;;
      esac
      pause
      ;;
    3)
      clear
      selected "Reload Cloudflare"
      reload_cloudflare
      pause
      ;;
    4)
      clear
      selected "Reload Nginx"
      reload_nginx
      pause
      ;;
    5)
      clear
      selected "Restart PM2"
      reload_pm2
      pause
      ;;
    q)
      clear
      exit 0
      ;;
  esac
done
