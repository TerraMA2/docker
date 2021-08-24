#!/bin/bash

docker volume create jenkins_home
docker network create --scope swarm --attachable admin_net

docker service create --name jenkins -d \
        --hostname=jenkins \
        --restart-condition=on-failure \
        --restart-max-attempts=2 \
        --env JENKINS_OPTS="--prefix=/jenkins" \
        --mount type=volume,src=jenkins_home,dst=/var/jenkins_home \
        --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
        --mount type=bind,src=/var/lib/docker/volumes,dst=/var/lib/docker/volumes \
        --mount type=bind,src=$(which docker),dst=$(which docker) \
        --network admin_net \
        --publish 36062:8080 jenkins/jenkins:2.307-jdk11
