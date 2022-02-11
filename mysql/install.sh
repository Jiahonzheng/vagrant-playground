#!/bin/bash

function check_env() {
  eval var=\$${1}
  if [ "${var}" == "" ]; then
    echo "Error: Empty ${1} environment variable."
    exit 1
  fi
}

check_env PASSWORD

NAME=mysql
DATA_DIR=${HOME}/data/${NAME}
MYSQL_VERSION=5.7

mkdir -p ${DATA_DIR}/conf ${DATA_DIR}/data ${DATA_DIR}/logs

sudo nerdctl \
  run \
  -d \
  --name ${NAME} \
  --restart=always \
  -p 3306:3306 \
  -v ${DATA_DIR}/conf:/etc/mysql/conf.d \
  -v ${DATA_DIR}/data:/var/lib/mysql \
  -v ${DATA_DIR}/logs:/logs \
  -e MYSQL_ROOT_PASSWORD=${PASSWORD} \
  mysql:${MYSQL_VERSION}
