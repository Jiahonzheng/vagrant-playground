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
  sudo systemctl enable --now containerd
}

case ${1} in
install)
  install
  ;;
*)
  echo "Error: Cannot execute \"${1}\" command."
  ;;
esac
