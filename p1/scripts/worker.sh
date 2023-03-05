#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${YELLOW}[SCRIPT] Add master to /etc/hosts${NC}"
echo "192.168.56.110 sclamS" >> /etc/hosts

echo -e "${YELLOW}[SCRIPT] Install k3s${NC}"
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" K3S_URL=https://sclamS:6443 K3S_TOKEN=$(cat /vagrant/.token) INSTALL_K3S_EXEC="--flannel-iface eth1" sh -s -