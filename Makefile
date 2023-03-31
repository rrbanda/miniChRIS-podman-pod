.PHONY: create-volume-chris-db
create-volume-chris-db:
	sudo podman volume create chris_db

.PHONY: run-chris-db-pod
run-chris-db-pod:
	sudo podman play kube dev-env/pods/chris-db-pod.yaml --configmap=dev-env/pods/secrets.yml

.PHONY: run-worker-pod
run-worker-pod:
	sudo podman play kube dev-env/pods/worker-pod.yaml --configmap=dev-env/pods/secrets.yml

.PHONY: run-chris-pod
run-chris-pod:
	sudo podman play kube dev-env/pods/chris-pod.yaml --configmap=dev-env/pods/secrets.yml

.PHONY: run-rabbit-mq-pod
run-rabbit-mq-pod:
	sudo podman play kube dev-env/pods/rabbit-mq-pod.yaml

.PHONY: run-scheduler-pod
run-scheduler-pod:
	sudo podman play kube dev-env/pods/scheduler-pod.yaml --configmap=dev-env/pods/secrets.yml

.PHONY: run-pfcon-pod
run-pfcon-pod:
	sudo podman play kube dev-env/pods/pfcon-nonroot-user-volume-fix-pod.yaml

.PHONY: run-
run-chris-pod:
	sudo podman play kube dev-env/pods/chris-pod.yaml --configmap=dev-env/pods/secrets.yml

.PHONY: reset-podman
reset-podman:
	sudo podman system reset

.PHONY: all
all: create-volume-chris-db run-chris-db-pod run-worker-pod run-chris-pod