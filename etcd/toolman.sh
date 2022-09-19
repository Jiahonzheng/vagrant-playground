#!/bin/bash

set -e

cd "$(dirname $(realpath $0))"/..
source util/common.sh

NAME=etcd
NAMESPACE="${NAMESPACE:-default}"
DATA_DIR=${HOME}/data/${NAMESPACE}/${NAME}
ETCD_VERSION=3.5.4
NETWORK="${NETWORK:-bridge}"

function install() {
  check_env NODE
  check_env HOST_IP
  check_env CLUSTER
  check_env CLUSTER_STATE
  check_env CLUSTER_TOKEN

  mkdir -p ${DATA_DIR}/data

  sudo nerdctl \
    run \
    -d \
    --name ${NAME} \
    -p 2380:2380 \
    -p 2379:2379 \
    -v ${DATA_DIR}/data:/etcd-data \
    quay.io/coreos/etcd:v${ETCD_VERSION} \
    /usr/local/bin/etcd \
    --data-dir=/etcd-data \
    -name etcd-${NODE} \
    -advertise-client-urls http://${HOST_IP}:2379 \
    -listen-client-urls http://0.0.0.0:2379 \
    -initial-advertise-peer-urls http://${HOST_IP}:2380 \
    -listen-peer-urls http://0.0.0.0:2380 \
    -initial-cluster ${CLUSTER} \
    -initial-cluster-state ${CLUSTER_STATE} \
    -initial-cluster-token ${CLUSTER_TOKEN}
}

case ${1} in
install)
  install
  ;;
*)
  echo "Error: Cannot execute \"${1}\" command."
  ;;
esac
