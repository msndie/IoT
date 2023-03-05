#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${YELLOW}[SCRIPT] Install k3s${NC}"
curl -sfL https://get.k3s.io/ | sh -s - --write-kubeconfig-mode 644
sleep 1
echo -e "${YELLOW}[SCRIPT] applying manifests${NC}"
kubectl apply -f /vagrant/confs
echo -e "${GREEN}[SCRIPT] DONE!${NC}"
