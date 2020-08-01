#!/bin/bash

echo "***********************"
echo "* Building SatAlertas *"
echo "***********************"
echo ""

eval $(egrep -v '^#' .env | xargs)

docker-compose -f satalertas/docker-compose.yml -p ${TERRAMA2_PROJECT_NAME} down --rmi all -v

docker-compose -f satalertas/docker-compose.yml -p ${TERRAMA2_PROJECT_NAME} up --build --force-recreate -d

service nginx reload