#!/bin/bash 
make create-podman-network-chris
make run-podman-network-chris
sudo podman network ls || exit $?

make create-volume-chris-db
make run-chris-db-pod
sudo podman pod ps || exit $?

make create-volume-chris-store-db
make run-chris-store-db-pod
sudo podman pod ps || exit $?

make create-volume-swift
make run-swift-pod
sudo podman pod ps || exit $?

make run-cube-pod
sudo podman pod ps || exit $?

make run-chris-ui-pod
sudo podman pod ps || exit $?

make run-chris-store-pod
sudo podman pod ps || exit $?

make run-chris-store-ui-pod
sudo podman pod ps || exit $?

make run-worker-pod
sudo podman pod ps || exit $?

make run-rabbit-mq-pod
sudo podman pod ps || exit $?

make create-volume-orthanc
make run-orthanc-plugins-pod
sudo podman pod ps || exit $?

make run-scheduler-pod
sudo podman pod ps || exit $?

make create-volume-pfdcm
make run-pfdcm-pod
sudo podman pod ps || exit $?

make run-pfdcm-listener-pod
sudo podman pod ps || exit $?

make create-volume-pfcon
make run-pfcon-pod
sudo podman pod ps || exit $?

make create-volume-pman
make run-pman-pod
sudo podman pod ps || exit $?

echo "Waiting for all pods to be ready..."
echo "Sleeping 60s..."
sleep 60s
        
sudo podman ps 
sudo podman ps --all --format "{{.Names}} {{.Ports}} {{.Mounts}} {{.Status}}"
sudo podman stats --no-stream
sudo podman pod stats --no-stream