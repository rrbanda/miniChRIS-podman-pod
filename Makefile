.PHONY: create-volume
create-volume:
	sudo podman volume create chris-db && sudo podman volume create chris_db_data

.PHONY: run-playbook
run-playbook:
	sudo podman play kube development-pod.yaml --configmap=secrets.yml

.PHONY: reset-podman
reset-podman:
	sudo podman system reset



	sudo podman play kube chris-db-pod.yaml --configmap=secrets.yml  --down