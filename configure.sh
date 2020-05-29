#!/bin/bash

eval $(egrep -v '^#' .env | xargs)

./configure-version.sh

docker volume create terrama2_pg_vol

docker run -d \
           --restart unless-stopped --name terrama2_pg \
           -p 127.0.0.1:5433:5432 \
           -v terrama2_pg_vol:/var/lib/postgresql/data \
           -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
           mdillon/postgis

docker volume create terrama2_shared_vol

docker-compose -p ${TERRAMA2_PROJECT_NAME} up -d

docker network connect ${TERRAMA2_PROJECT_NAME}_net terrama2_pg