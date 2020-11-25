#!/bin/bash

echo "*********************************"
echo "* Creating PostgreSQL container *"
echo "*********************************"
echo ""

eval $(egrep -v '^#' .env | xargs)

docker volume create terrama2_pg_vol

docker run -d \
           --restart unless-stopped --name terrama2_pg \
           -p 127.0.0.1:5435:5432 \
           -v terrama2_pg_vol:/var/lib/postgresql/data \
           -e POSTGRES_PASSWORD="postgres" \
           postgis/postgis:11-2.5
