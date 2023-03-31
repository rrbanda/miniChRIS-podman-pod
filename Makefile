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

.PHONY: run-chris-db-pod
run-chris-db-pod:
	sudo podman play kube --network chris dev-env/pods/chris-db-pod.yaml --configmap=dev-env/pods/secrets.yml

.PHONY: run-chris-store-db-pod
run-chris-store-db-pod:
	sudo podman play kube --network chris dev-env/pods/chris-store-db-pod.yaml --configmap=dev-env/pods/secrets.yml

.PHONY: run-swift-pod
run-swift-pod:
	sudo podman play kube --network chris dev-env/pods/swift-pod.yaml --configmap=dev-env/pods/secrets.yml

.PHONY: run-chris-pod
run-chris-pod:
	sudo podman play kube --network chris dev-env/pods/chris-pod.yaml --configmap=dev-env/pods/secrets.yml

.PHONY: run-chris-store-pod
run-chris-store-pod:
	sudo podman play kube --network chris dev-env/pods/chris-store-pod.yaml --configmap=dev-env/pods/secrets.yml

.PHONY: run-chris-ui-pod
run-chris-ui-pod:
	sudo podman play kube --network chris dev-env/pods/chris-ui-pod.yaml

.PHONY: run-rabbit-mq-pod
run-rabbit-mq-pod:
	sudo podman play kube --network chris dev-env/pods/rabbit-mq-pod.yaml

.PHONY: run-scheduler-pod
run-scheduler-pod:
	sudo podman play kube --network chris dev-env/pods/scheduler-pod.yaml --configmap=dev-env/pods/secrets.yml

.PHONY: run-pfcon-pod
run-pfcon-pod:
	sudo podman play kube --network chris dev-env/pods/pfcon-nonroot-user-volume-fix-pod.yaml

.PHONY: run-worker-pod
run-worker-pod:
	sudo podman play kube --network chris dev-env/pods/worker-pod.yaml --configmap=dev-env/pods/secrets.yml

.PHONY: reset-podman
reset-podman:
	sudo podman system reset

.PHONY: all
all: create-volume-chris-db run-chris-db-pod run-worker-pod run-chris-pod