#!/bin/bash

# Get pod information
pod_info=$(sudo podman pod ps)

# Remove header row and get pod name and number of containers
pod_data=$(echo "$pod_info" | awk 'NR>1 {print $2 " " $NF}')

# Loop through pod data and check if number of containers equals 2
for data in $pod_data; do
  name=$(echo "$data" | awk '{print $1}')
  num=$(echo "$data" | awk '{print $2}')
  if [ "$num" != "2" ]; then
    echo "Error: $name has $num containers, expected 2"
    exit 1
  fi
done

echo "All pods have exactly 2 containers"
exit 0