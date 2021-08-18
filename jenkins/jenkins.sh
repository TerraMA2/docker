#!/bin/bash

docker volume create jenkins_home
docker network create --scope swarm --internal --attachable admin_net

#docker run --name=jenkins -d \
#      --privileged \
#      --restart=always \
#      --env JENKINS_OPTS="--prefix=/jenkins" \
#      -v jenkins_home:/var/jenkins_home \
#      --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
#      -v $(which docker):$(which docker) \
#      --network admin_net \
#      -p 36062:8080 jenkins/jenkins:latest-jdk11

docker service create --name jenkins -d \
        --restart-condition=on-failure \
        --restart-max-attempts=2 \
        --env JENKINS_OPTS="--prefix=/jenkins" \
        --mount type=volume,src=jenkins_home,dst=/var/jenkins_home \
        --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
        --mount type=bind,src=$(which docker),dst=$(which docker) \
        --network admin_net \
        --publish 36062:8080 jenkins/jenkins:latest-jdk11
