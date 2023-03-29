#!/bin/bash -x
set -xe -o pipefail
if ! [ -x "$(command -v kubeval)" ]; then
  echo "kubeval not found, installing..."
    wget https://github.com/instrumenta/kubeval/releases/latest/download/kubeval-linux-amd64.tar.gz
    tar xf kubeval-linux-amd64.tar.gz
    sudo cp kubeval /usr/local/bin
fi

make reset-podman
kubeval development-pod.yaml || exit 1
make create-volume
make run-playbook