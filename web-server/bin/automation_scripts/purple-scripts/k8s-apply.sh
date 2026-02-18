#!/bin/bash
set -e
source "$(dirname "$0")/lib.sh"

MANIFEST_DIR="$HOME/k8s-manifests"

while true; do
  clear
  menu_title "K8s Apply"

  menu_item "1)" "Grades-fe"
  menu_item "2)" "Grades-be"
  menu_item "3)" "Secrets"
  menu_item "4)" "MongoDB"
  menu_item "5)" "Keel"

  menu_sep
  menu_item "a)" "All"
  menu_sep
  menu_item "q)" "Back"

  menu_hint

  read -r -n1 choice
  echo

  clear

  case "$choice" in
    1)
      title "Applying Grades Frontend"
      sudo kubectl apply -f "$MANIFEST_DIR/purplebytes-grades/grades-frontend.yaml"
      ;;
    2)
      title "Applying Grades Backend"
      sudo kubectl apply -f "$MANIFEST_DIR/purplebytes-grades/grades-backend.yaml"
      ;;
    3)
      title "Applying Secrets (Local Only)"
      sudo kubectl apply -f "$MANIFEST_DIR/secrets.yaml"
      ;;
    4)
      title "Applying MongoDB (Infra)"
      sudo kubectl apply -f "$MANIFEST_DIR/infra/mongo.yaml"
      ;;
    5)
      title "Applying Keel (Automation)"
      sudo kubectl apply -f "$MANIFEST_DIR/infra/keel.yaml"
      ;;
    a)
      title "Applying EVERYTHING"
      sudo kubectl apply -f "$MANIFEST_DIR/secrets.yaml"
      sudo kubectl apply -f "$MANIFEST_DIR/infra/"
      sudo kubectl apply -f "$MANIFEST_DIR/purplebytes-grades/"
      ;;
    q)
      echo "Exiting..."
      exit 0
      ;;
    *)
      echo -e "\033[31mInvalid option\033[0m"
      ;;
  esac

  pause
done
