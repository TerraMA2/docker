#!/bin/bash

docker volume create portainer_data
docker network create --scope swarm --internal --attachable admin_net

#docker run --name=portainer -d \
#            --restart=unless-stopped \
#            --privileged \
#            -p 36060:9000 \
#            --network admin_net \
#            --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
#            --mount type=bind,src=/var/lib/docker/volumes,dst=/var/lib/docker/volumes \
#            -v portainer_data:/data portainer/portainer-ce:alpine

docker service create --name=portainer -d \
                      --restart-condition=on-failure \
                      --restart-max-attempts=2 \
                      --publish 36060:9000 \
                      --network admin_net \
                      --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
                      --mount type=bind,src=/var/lib/docker/volumes,dst=/var/lib/docker/volumes \
                      --mount type=volume,src=portainer_data,dst=/data portainer/portainer-ce:alpine
