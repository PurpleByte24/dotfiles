#!/bin/bash
set -e
source "$(dirname "$0")/lib.sh"

MANIFEST_DIR="$HOME/k8s-manifests"

while true; do
  clear
  menu_title "K8s Apply"

  menu_item "1)" "purplebytes-grades"
  menu_item "2)" "infra"
  menu_item "3)" "secrets"

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
      title "Applying purplebytes-grades"
      sudo kubectl apply -f "$MANIFEST_DIR/purplebytes-grades/"
      ;;
    2)
      title "Applying infra"
      sudo kubectl apply -f "$MANIFEST_DIR/infra/"
      ;;
    3)
      title "Applying Secrets"
      sudo kubectl apply -f "$MANIFEST_DIR/secrets.yaml"
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
