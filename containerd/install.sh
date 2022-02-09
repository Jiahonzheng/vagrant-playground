#!/bin/bash

CONTAINERD_VERSION=1.5.9
NERDCTL_VERSION=0.16.1

# Install containerd.
# https://github.com/containerd/containerd/blob/main/docs/cri/installation.md
sudo apt-get update
sudo apt-get install libseccomp2
wget https://github.com/containerd/containerd/releases/download/v${CONTAINERD_VERSION}/cri-containerd-cni-${CONTAINERD_VERSION}-linux-amd64.tar.gz
sudo tar --no-overwrite-dir -C / -xzf cri-containerd-cni-${CONTAINERD_VERSION}-linux-amd64.tar.gz
sudo systemctl daemon-reload
sudo systemctl start containerd

# Install nerdctl.
# https://github.com/containerd/nerdctl/releases
wget https://github.com/containerd/nerdctl/releases/download/v${NERDCTL_VERSION}/nerdctl-${NERDCTL_VERSION}-linux-amd64.tar.gz
tar -zxvf nerdctl-${NERDCTL_VERSION}-linux-amd64.tar.gz nerdctl
sudo mv nerdctl /usr/local/bin/
