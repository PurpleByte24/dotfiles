#!/bin/bash
set -e
source "$(dirname "$0")/lib.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm use default > /dev/null

# ---------- GRSA ----------
update_grsa_fe() {
  title "GRSA frontend"
  REPO="/home/apps/repos/grsa-fe"
  TARGET="/var/www/grsa-fe"

  cd "$REPO"
  git pull
  rm -rf node_modules/
  npm ci
  npm run build

  rm -rf "$TARGET"/*
  cp -r dist/* "$TARGET"/

  reload_nginx
}

update_grsa_be() {
  title "GRSA backend"
  REPO="/home/apps/repos/grsa-be"
  TARGET="/var/www/grsa-be"

  cd "$REPO"
  git pull
  npm install
  npm run build

  rm -rf "$TARGET"/*
  cp package.json package-lock.json "$TARGET"/
  cp .env.server "$TARGET/.env"
  cp -r dist "$TARGET"/

  cd "$TARGET"
  npm install --omit=dev

  pm2 delete grsa-backend || true
  pm2 start npm --name grsa-backend -- start --prefix "$TARGET"
}

# ---------- GRADES ----------
update_grades_fe() {
  title "GRADES frontend"
  REPO="/home/apps/repos/grades-fe"
  TARGET="/var/www/grades-fe"

  cd "$REPO"
  git pull
  rm -rf node_modules/
  npm ci
  npm run build

  rm -rf "$TARGET"/*
  cp -r dist/* "$TARGET"/

  reload_nginx
}

update_grades_be() {
  title "GRADES backend"
  REPO="/home/apps/repos/grades-be"
  TARGET="/var/www/grades-be"

  cd "$REPO"
  git pull
  npm install
  npm run build

  rm -rf "$TARGET"/*
  cp package.json package-lock.json "$TARGET"/
  cp .env.server "$TARGET/.env"
  cp -r dist "$TARGET"/

  cd "$TARGET"
  npm install --omit=dev

  pm2 delete grades-backend || true
  pm2 start npm --name grades-backend -- start --prefix "$TARGET"
}

# ---------- project menu ----------
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
  clear
  menu_title "Update"

  menu_item "1)" "GRSA"
  menu_item "2)" "GRADES"
  menu_sep
  menu_item "q)" "Quit"

  menu_hint
  read -r -n1 main
  echo

  case "$main" in
    1)
      project_menu
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
      case "$PROJECT_CHOICE" in
        1) update_grades_fe ;;
        2) update_grades_be ;;
        3)
          update_grades_fe
          update_grades_be
          ;;
      esac
      pause
      ;;
    q) exit 0 ;;
  esac
done
