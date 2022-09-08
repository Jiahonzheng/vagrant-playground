#!/bin/bash

set -e

cd "$(dirname $(realpath $0))"/..
source util/common.sh

function install() {
  curl -fsSL https://tailscale.com/install.sh | sh
  sudo tailscale up
}

case ${1} in
install)
  install
  ;;
*)
  echo "Error: Cannot execute \"${1}\" command."
  ;;
esac
