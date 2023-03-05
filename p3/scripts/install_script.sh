#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

if [ "$EUID" -ne 0 ]
  then echo -e "${RED}[SCRIPT] Please run as root${NC}"
  exit
fi

# TODO change for ubuntu
echo -e "${YELLOW}[SCRIPT] Installing docker${NC}"
pacman -S --needed docker

echo -e "${YELLOW}[SCRIPT] Starting docker service${NC}"
systemctl start docker.service
systemctl enable docker.service

KUBECTL=/usr/local/bin/kubectl
if [ -f "$KUBECTL" ]; then
    echo -e "${RED}[SCRIPT] kubectl already installed${NC}"
else
    echo -e "${YELLOW}[SCRIPT] Installing kubectl${NC}"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
    chmod +x kubectl
    mv ./kubectl /usr/local/bin
fi

K3D=/usr/local/bin/k3d
if [ -f "$K3D" ]; then
    echo -e "${RED}[SCRIPT] k3d already installed${NC}"
else 
    echo -e "${YELLOW}[SCRIPT] Installing k3d${NC}"
    wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
fi