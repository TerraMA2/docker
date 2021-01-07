#!/bin/bash

./configure-version.sh

eval $(egrep -v '^#' .env | xargs)

./create-postgres.sh

docker volume create terrama2_shared_vol

docker-compose -p ${COMPOSE_PROJECT_NAME} -f docker-compose-dev.yml up -d

docker network connect ${COMPOSE_PROJECT_NAME}_net terrama2_pg

chown 1000:1000 conf/terrama2_webapp_settings.json
chown 1000:1000 conf/terrama2_webapp_db.json

# Using Geoserver without docker
#cd /home/$(id -nu 1000) || exit

#if test -d "geoserver-2.18.1"; then
#    echo "Geoserver already installed"
#else
#    wget -O geoserver-2.18.1-bin.zip -L https://ufpr.dl.sourceforge.net/project/geoserver/GeoServer/2.18.1/geoserver-2.18.1-bin.zip
#    unzip geoserver-2.18.1-bin.zip -d ~/geoserver-2.18.1
#    rm -f geoserver-2.18.1-bin.zip
#fi
