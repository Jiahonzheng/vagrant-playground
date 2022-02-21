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

# Install BuildKit.
wget https://github.com/moby/buildkit/releases/download/v${BUILDKIT_VERSION}/buildkit-v${BUILDKIT_VERSION}.linux-amd64.tar.gz
sudo tar -zxvf buildkit-v${BUILDKIT_VERSION}.linux-amd64.tar.gz -C /usr/local
echo "
[Unit]
Description=BuildKit
Documentation=https://github.com/moby/buildkit

[Socket]
ListenStream=%t/buildkit/buildkitd.sock

[Install]
WantedBy=sockets.target
" | sudo tee /etc/systemd/system/buildkit.socket
echo "
[Unit]
Description=BuildKit
Requires=buildkit.socket
After=buildkit.socketDocumentation=https://github.com/moby/buildkit

[Service]
ExecStart=/usr/local/bin/buildkitd --oci-worker=false --containerd-worker=true

[Install]
WantedBy=multi-user.target
" | sudo tee /etc/systemd/system/buildkit.service
sudo systemctl daemon-reload
sudo systemctl start buildkit
