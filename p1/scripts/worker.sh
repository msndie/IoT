#!/bin/bash

echo "[SCRIPT] Add master to /etc/hosts"
echo "192.168.56.110 sclamS" >> /etc/hosts

echo "[SCRIPT] Install k3s"
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" K3S_URL=https://sclamS:6443 K3S_TOKEN=$(cat /vagrant/.token) INSTALL_K3S_EXEC="--flannel-iface eth1" sh -s -