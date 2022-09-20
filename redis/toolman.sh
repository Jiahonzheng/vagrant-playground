#!/bin/bash

set -e

cd "$(dirname $(realpath $0))"/..
source util/common.sh

NAME=redis
NAMESPACE="${NAMESPACE:-default}"
DATA_DIR=${HOME}/data/${NAMESPACE}/${NAME}
REDIS_VERSION=6.2.6-alpine
NETWORK="${NETWORK:-podman}"

function install() {
  check_env PASSWORD

  mkdir -p ${DATA_DIR}/data

  podman \
    run \
    -d \
    --name ${NAMESPACE}.${NAME} \
    --network ${NETWORK} \
    -p 6379:6379 \
    -v ${DATA_DIR}/data:/data \
    docker.io/redis:${REDIS_VERSION} \
    redis-server \
    --appendonly yes \
    --requirepass ${PASSWORD}
}

case ${1} in
install)
  install
  ;;
*)
  echo "Error: Cannot execute \"${1}\" command."
  ;;
esac
