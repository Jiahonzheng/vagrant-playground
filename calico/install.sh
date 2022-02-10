#!/bin/bash

function check_env() {
  eval var=\$$1
  if [ "$var" == "" ]; then
    echo "Error: Empty $1 environment variable."
    exit 1
  fi
}

check_env IP
check_env ETCD_ENDPOINTS

NAME=calico-node
CALICO_VERSION=3.22.0

# Install calicoctl.
sudo wget -O /usr/local/bin/calicoctl https://github.com/projectcalico/calico/releases/download/v${CALICO_VERSION}/calicoctl-linux-amd64
sudo chmod +x /usr/local/bin/calicoctl

# Configure calicoctl.
sudo mkdir -p /etc/calico
echo "apiVersion: projectcalico.org/v3
kind: CalicoAPIConfig
metadata:
spec:
  etcdEndpoints: ${ETCD_ENDPOINTS}" | sudo tee /etc/calico/calicoctl.cfg

# Install Calico node.
sudo mkdir -p /var/log/calico /var/lib/calico /var/run/calico
sudo nerdctl run \
  -d \
  --restart=always \
  --name=${NAME} \
  --net=host \
  --privileged \
  -e NODENAME=${HOSTNAME,,} \
  -e CALICO_NETWORKING_BACKEND=bird \
  -e IP=${IP} \
  -e DATASTORE_TYPE=etcdv3 \
  -e ETCD_ENDPOINTS=${ETCD_ENDPOINTS} \
  -e ENABLED_CONTROLLERS= \
  -e CALICO_MANAGE_CNI=false \
  -v /var/log/calico:/var/log/calico \
  -v /var/run/calico:/var/run/calico \
  -v /var/lib/calico:/var/lib/calico \
  -v /lib/modules:/lib/modules \
  -v /run:/run \
  calico/node:v${CALICO_VERSION}

# Install Calico plugins.
VOLUME_NAME=calico-cni-plugins
VOLUME_PATH=/var/lib/nerdctl/$(echo -n "/run/containerd/containerd.sock" | sha256sum | cut -c1-8)/volumes/default/${VOLUME_NAME}/_data
CNI_PATH=/opt/cni/bin
sudo nerdctl volume create ${VOLUME_NAME}
sudo nerdctl run --rm -v ${VOLUME_NAME}:/opt/cni/bin calico/cni:v${CALICO_VERSION}
sudo cp ${VOLUME_PATH}/calico ${CNI_PATH}
sudo cp ${VOLUME_PATH}/calico-ipam ${CNI_PATH}
sudo nerdctl volume rm ${VOLUME_NAME}

# Add Calico network.
echo "{
  \"name\": \"calico\",
  \"cniVersion\": \"0.3.1\",
  \"plugins\": [
    {
      \"type\": \"calico\",
      \"log_level\": \"info\",
      \"log_file_path\": \"/var/log/calico/cni/cni.log\",
      \"datastore_type\": \"etcdv3\",
      \"etcd_endpoints\": \"${ETCD_ENDPOINTS}\",
      \"nodename\": \"${HOSTNAME,,}\",
      \"mtu\": 0,
      \"ipam\": {
          \"type\": \"calico-ipam\"
      },
      \"container_settings\": {
          \"allow_ip_forwarding\": true
      }
    },
    {
      \"type\": \"portmap\",
      \"snat\": true,
      \"capabilities\": {\"portMappings\": true}
    }
  ]
}" | sudo tee /etc/cni/net.d/10-calico-containerd.conflist
