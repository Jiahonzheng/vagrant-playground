#!/bin/bash

function check_env() {
  eval var=\$${1}
  if [ "${var}" == "" ]; then
    echo "Error: Empty ${1} environment variable."
    exit 1
  fi
}

check_env NODE
check_env HOST_IP
check_env CLUSTER
check_env CLUSTER_STATE

NAME=etcd
DATA_DIR=${HOME}/data/${NAME}
ETCD_VERSION=3.5.1
CLUSTER_TOKEN=etcd-cluster

mkdir -p ${DATA_DIR}/data

sudo nerdctl \
  run \
  -d \
  --name ${NAME} \
  --restart=always \
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
  -initial-cluster-token ${CLUSTER_TOKEN} \
  -initial-cluster ${CLUSTER} \
  -initial-cluster-state ${CLUSTER_STATE}
