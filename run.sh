#!/usr/bin/env bash

#Create Docker network
docker network create --driver=bridge --opt com.docker.network.bridge.enable_ip_masquerade=true snort2_network

# Run a container with privileged access
# username is snorty

docker run --rm --name snort2 -h snort2 -u snorty --privileged --network snort2_network -d -it snort2-image2 /bin/bash

# # Execute a container
docker exec -it --user root snort2 /bin/bash