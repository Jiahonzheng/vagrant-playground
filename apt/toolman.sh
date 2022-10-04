#!/bin/bash

set -e

cd "$(dirname $(realpath $0))"/..
source util/common.sh

function install() {
  wget https://github.com/SuperManito/LinuxMirrors/raw/main/ChangeMirrors.sh
  sudo bash ChangeMirrors.sh
  rm -f ChangeMirrors.sh
}

case ${1} in
install)
  install
  ;;
*)
  echo "Error: Cannot execute \"${1}\" command."
  ;;
esac
