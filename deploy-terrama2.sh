#!/bin/bash

eval $(egrep -v '^#' .env | xargs)

sudo docker-compose -p ${TERRAMA2_PROJECT_NAME} down

sudo docker-compose -p ${TERRAMA2_PROJECT_NAME} pull

sudo docker-compose -p ${TERRAMA2_PROJECT_NAME} up -d