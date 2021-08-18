#!/bin/bash

./scripts/configure-version.sh

eval $(egrep -v '^#' .env | xargs)

./scripts/create-postgres.sh

docker volume create terrama2_shared_vol

docker-compose -p ${COMPOSE_PROJECT_NAME} up -d

docker network connect ${COMPOSE_PROJECT_NAME}_net terrama2_postgres

chown 1000:1000 conf/terrama2_webapp_settings.json
chown 1000:1000 conf/terrama2_webapp_db.json
