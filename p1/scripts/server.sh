#!/bin/bash

echo "[SCRIPT] Install k3s"
curl -sfL https://get.k3s.io/ | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--flannel-iface eth1" sh -s -

echo "[SCRIPT] Copy token"
echo $(cat /var/lib/rancher/k3s/server/node-token) > /vagrant/.token