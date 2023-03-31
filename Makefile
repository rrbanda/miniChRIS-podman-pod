.PHONY: run-podman-network-chris
create-podman-network-chris:
	sudo podman network create chris

.PHONY: create-volume-chris-db
create-volume-chris-db:
	sudo podman volume create chris_db

.PHONY: create-volume-chris-store-db
create-volume-chris-store-db:
	sudo podman volume create chris_store_db

.PHONY: create-volume-swift
create-volume-swift:
	sudo podman volume create swift

.PHONY: create-volume-orthanc
create-volume-orthanc:
	sudo podman volume create orthanc

.PHONY: create-volume-pfdcm
create-volume-pfdcm:
	sudo podman volume create pfdcm

.PHONY: create-volume-pman
create-volume-pman:
	sudo podman volume create pman

.PHONY: create-volume-pfcon
create-volume-pfcon:
	sudo podman volume create pfcon

.PHONY: run-chris-db-pod
run-chris-db-pod:
	sudo podman play kube --network chris dev-env/pods/chris-db-pod.yaml --configmap=dev-env/pods/secrets.yml

.PHONY: run-chris-store-db-pod
run-chris-store-db-pod:
	sudo podman play kube --network chris dev-env/pods/chris-store-db-pod.yaml --configmap=dev-env/pods/secrets.yml

.PHONY: run-swift-pod
run-swift-pod:
	sudo podman play kube --network chris dev-env/pods/swift-pod.yaml --configmap=dev-env/pods/secrets.yml

.PHONY: run-cube-pod
run-cube-pod:
	sudo podman play kube --network chris dev-env/pods/cube-pod.yaml --configmap=dev-env/pods/secrets.yml

.PHONY: run-chris-store-pod
run-chris-store-pod:
	sudo podman play kube --network chris dev-env/pods/chris-store-pod.yaml --configmap=dev-env/pods/secrets.yml

.PHONY: run-chris-store-ui-pod
run-chris-store-ui-pod:
	sudo podman play kube --network chris dev-env/pods/chris-store-ui-pod.yaml --configmap=dev-env/pods/secrets.yml

.PHONY: run-chris-ui-pod
run-chris-ui-pod:
	sudo podman play kube --network chris dev-env/pods/chris-ui-pod.yaml

.PHONY: run-rabbit-mq-pod
run-rabbit-mq-pod:
	sudo podman play kube --network chris dev-env/pods/rabbit-mq-pod.yaml

.PHONY: run-scheduler-pod
run-scheduler-pod:
	sudo podman play kube --network chris dev-env/pods/scheduler-pod.yaml --configmap=dev-env/pods/secrets.yml

.PHONY: run-pfdcm-pod
run-pfdcm-pod:
	sudo podman play kube --network chris dev-env/pods/pfdcm-pod.yaml

.PHONY: run-pfdcm-listener-pod
run-pfdcm-listener-pod:
	sudo podman play kube --network chris dev-env/pods/pfdcm-listener-pod.yaml

.PHONY: run-pfcon-pod
run-pfcon-pod:
	sudo podman play kube --network chris dev-env/pods/pfcon-nonroot-user-volume-fix-pod.yaml

.PHONY: run-worker-pod
run-worker-pod:
	sudo podman play kube --network chris dev-env/pods/worker-pod.yaml --configmap=dev-env/pods/secrets.yml

.PHONY: run-pman-pod
run-pman-pod:
	sudo podman play kube --network chris dev-env/pods/pman-pod.yaml --configmap=dev-env/pods/secrets.yml

.PHONY: run-orthanc-plugins-pod
run-orthanc-plugins-pod:
	sudo podman play kube --network chris dev-env/pods/orthanc-plugins-pod.yaml --configmap=dev-env/pods/secrets.yml

.PHONY: reset-podman
reset-podman:
	sudo podman system reset

.PHONY: all
all: create-volume-chris-db run-chris-db-pod run-worker-pod run-chris-pod