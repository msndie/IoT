#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${YELLOW}[SCRIPT] Install k3s${NC}"
curl -sfL https://get.k3s.io/ | K3S_KUBECONFIG_MODE="644" K3S_TOKEN="IoT-Token" INSTALL_K3S_EXEC="--flannel-iface eth1" sh -s -