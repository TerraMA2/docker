#!/bin/bash

echo "*********************************"
echo "* Creating PostgreSQL container *"
echo "*********************************"
echo ""

eval $(egrep -v '^#' .env | xargs)

docker volume create terrama2_postgres_vol

docker run -d \
           --restart unless-stopped --name terrama2_postgres \
           -p 0.0.0.0:5435:5432 \
           -v terrama2_postgres_vol:/var/lib/postgresql/data \
           -e POSTGRES_PASSWORD="postgres" \
           --ipc=host \
           --shm-size 128m \
           postgis/postgis:11-2.5

docker network connect ${COMPOSE_PROJECT_NAME}_net terrama2_postgres