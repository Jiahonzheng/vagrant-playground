#!/bin/bash

set -e

cd "$(dirname $(realpath $0))"/..
source util/common.sh

NERDCTL_VERSION=0.23.0

if [[ "${USE_MIRROR}" == "1" ]]; then
  DOWNLOAD_DOMAIN=download.fastgit.org
else
  DOWNLOAD_DOMAIN=github.com
fi

function install() {
  if [[ "${USE_LOCAL}" == "" ]]; then
    wget https://${DOWNLOAD_DOMAIN}/containerd/nerdctl/releases/download/v${NERDCTL_VERSION}/nerdctl-full-${NERDCTL_VERSION}-linux-amd64.tar.gz
  fi
  sudo tar Cxzvvf /usr/local nerdctl-full-${NERDCTL_VERSION}-linux-amd64.tar.gz
  sudo cp /usr/local/lib/systemd/system/*.service /etc/systemd/system/
  sudo systemctl enable --now containerd
}

function upgrade() {
  if [[ "${USE_LOCAL}" == "" ]]; then
    wget https://${DOWNLOAD_DOMAIN}/containerd/nerdctl/releases/download/v${NERDCTL_VERSION}/nerdctl-full-${NERDCTL_VERSION}-linux-amd64.tar.gz
  fi
  sudo tar Cxzvvf /usr/local nerdctl-full-${NERDCTL_VERSION}-linux-amd64.tar.gz
  sudo cp /usr/local/lib/systemd/system/*.service /etc/systemd/system/
  sudo systemctl restart containerd
  sudo systemctl enable containerd
}

case ${1} in
install)
  install
  ;;
upgrade)
  upgrade
  ;;
*)
  echo "Error: Cannot execute \"${1}\" command."
  ;;
esac
