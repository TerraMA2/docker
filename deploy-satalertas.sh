#!/bin/bash

echo "***********************"
echo "* Building SatAlertas *"
echo "***********************"
echo ""

eval $(egrep -v '^#' .env | xargs)

docker-compose -f satalertas/docker-compose.yml -p ${TERRAMA2_PROJECT_NAME} down

docker-compose -f satalertas/docker-compose.yml -p ${TERRAMA2_PROJECT_NAME} pull

docker-compose -f satalertas/docker-compose.yml -p ${TERRAMA2_PROJECT_NAME} up -d

service nginx reload