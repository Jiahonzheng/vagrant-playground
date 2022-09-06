#!/bin/bash

set -e

cd "$(dirname $(realpath $0))"/..
source util/common.sh

check_env PASSWORD

NAME=redis
DATA_DIR=${HOME}/data/${NAME}
REDIS_VERSION=6.2.6

mkdir -p ${DATA_DIR}/data

sudo nerdctl \
  run \
  -d \
  --name ${NAME} \
  --restart=always \
  -p 6379:6379 \
  -v ${DATA_DIR}/data:/data \
  redis:${REDIS_VERSION} \
  redis-server \
  --appendonly yes \
  --requirepass ${PASSWORD}
