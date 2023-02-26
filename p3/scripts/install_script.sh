#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "[SCRIPT] Please run as root"
  exit
fi

# TODO change for ubuntu
echo "[SCRIPT] Installing docker"
pacman -S --needed docker

echo "[SCRIPT] Starting docker service"
systemctl start docker.service
systemctl enable docker.service

KUBECTL=/usr/local/bin/kubectl
if [ -f "$KUBECTL" ]; then
    echo "[SCRIPT] kubectl already installed"
else
    echo "[SCRIPT] Installing kubectl"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
    chmod +x kubectl
    mv ./kubectl /usr/local/bin
fi

K3D=/usr/local/bin/k3d
if [ -f "$K3D" ]; then
    echo "[SCRIPT] k3d already installed"
else 
    echo "[SCRIPT] Installing k3d"
    wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
fi