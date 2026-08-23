#!/bin/bash

# Desired: All Docker containers running specific version
DESIRED_IMAGE="nginx:1.25"

for container in $(docker ps --format '{{.Names}}'); do
    image=$(docker inspect --format='{{.Config.Image}}' $container)
    if [ "$image" != "$DESIRED_IMAGE" ]; then
        echo "DRIFT DETECTED:"
        echo "Container $container"
        echo "running $image instead of $DESIRED_IMAGE"
        echo "---"
    fi
done
