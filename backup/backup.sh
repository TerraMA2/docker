#!/bin/bash

eval $(egrep -v '^#' ../.env | xargs)

DATE=$(date +%d-%m-%Y-%H-%M)

echo ""
echo "*******************"
echo "* Backup TerraMA² *"
echo "*******************"
echo ""

if test -d "/var/lib/docker/volumes/terrama2_postgres_vol/_data/"; then
    echo ""
    echo "**************"
    echo "* PostgreSQL *"
    echo "**************"

    echo ""
    echo "********************************************"
    echo "* Backing up database ${POSTGRES_DATABASE} *"
    echo "********************************************"

    docker exec -it terrama2_postgres bash -c "pg_dump -f /var/lib/postgresql/data/dump-${DATE}.sql -h localhost -p 5432 -U postgres --quote-all-identifiers --no-password -v --role=postgres -Fp -b -c -C ${POSTGRES_DATABASE}"

    mkdir -vp ${BACKUP_DIR}/postgresql

    echo ""
    echo "********************"
    echo "* Compacting dumps *"
    echo "********************"

    cd /var/lib/docker/volumes/terrama2_postgres_vol/_data/

    tar cvf - dump-${DATE}.sql | gzip -9 - > ${BACKUP_DIR}/postgresql/dump-${DATE}.tar.gz

    rm -f dump-${DATE}.sql
fi

echo ""
echo "*************"
echo "* Geoserver *"
echo "*************"
echo ""

if test -d "/var/lib/docker/volumes/${COMPOSE_PROJECT_NAME}_geoserver_vol/_data/"; then
    mkdir -vp ${BACKUP_DIR}/geoserver

    cd /var/lib/docker/volumes/${COMPOSE_PROJECT_NAME}_geoserver_vol/_data/

    tar cvf - * | gzip -9 - > ${BACKUP_DIR}/geoserver/geoserver-${DATE}.tar.gz
fi
