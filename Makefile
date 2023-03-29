.PHONY: create-volume
create-volume-chris-db:
	sudo podman volume create chris-db 

.PHONY: run-chris-db-pod
run-chris-db-pod:
	cd dev-env/pods
	sudo podman play kube chris-db-pod.yaml --configmap=secrets.yml

.PHONY: reset-podman
reset-podman:
	sudo podman system reset