#!/bin/bash

set -e

cd "$(dirname $(realpath $0))"/..
source util/common.sh

NAME=nginx
NAMESPACE="${NAMESPACE:-default}"
DATA_DIR=${HOME}/data/${NAMESPACE}/${NAME}
NETWORK="${NETWORK:-bridge}"

function install() {
  cp -r nginx/data/* ${DATA_DIR}

  sudo nerdctl \
    run \
    --namespace ${NAMESPACE} \
    -d \
    --name ${NAME} \
    --network ${NETWORK} \
    -p 80:80 \
    -p 443:443 \
    -v ${DATA_DIR}/nginx.conf:/etc/nginx/nginx.conf \
    -v ${DATA_DIR}/conf:/etc/nginx/conf \
    -v ${DATA_DIR}/data:/etc/nginx/data \
    nginx
}

case ${1} in
install)
  install
  ;;
*)
  echo "Error: Cannot execute \"${1}\" command."
  ;;
esac
