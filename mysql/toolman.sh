#!/bin/bash

set -e

cd "$(dirname $(realpath $0))"/..
source util/common.sh

NAME=mysql
DATA_DIR=${HOME}/data/${NAME}
MYSQL_VERSION=8.0

function install() {
  check_env PASSWORD

  mkdir -p ${DATA_DIR}/conf ${DATA_DIR}/data ${DATA_DIR}/logs

  sudo nerdctl \
    run \
    -d \
    --name ${NAME} \
    -p 3306:3306 \
    -v ${DATA_DIR}/conf:/etc/mysql/conf.d \
    -v ${DATA_DIR}/data:/var/lib/mysql \
    -v ${DATA_DIR}/logs:/logs \
    -e MYSQL_ROOT_PASSWORD=${PASSWORD} \
    mysql:${MYSQL_VERSION}
}

case ${1} in
install)
  install
  ;;
*)
  echo "Error: Cannot execute \"${1}\" command."
  ;;
esac
