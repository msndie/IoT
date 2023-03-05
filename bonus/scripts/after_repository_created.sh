#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

if [ "$EUID" -ne 0 ]
  then echo -e "${RED}[SCRIPT] Please run as root${NC}"
  exit
fi

read -r -p "Do you create repository and edit argocd yaml files? [y/N]" response
case "$response" in
        [yY][eE][sS][yY])
            echo -e "${YELLOW}[SCRIPT] Applying argocd project and application manifests${NC}"
            kubectl apply -n argocd -f ../confs
            ;;
        *)
            echo -e "${RED}[SCRIPT] Come back after editing yaml files :)${NC}"
            ;;
esac