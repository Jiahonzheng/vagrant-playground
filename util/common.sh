#!/bin/bash

function check_env() {
  eval var=\$${1}
  if [ "${var}" == "" ]; then
    echo "Error: Empty ${1} environment variable."
    exit 1
  fi
}
