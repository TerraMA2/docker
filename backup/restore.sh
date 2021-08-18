#!/bin/bash

eval $(egrep -v '^#' ../.env | xargs)

echo ""
echo "********************"
echo "* Restore TerraMA² *"
echo "********************"

if test -d "/var/lib/docker/volumes/terrama2_postgres_vol/_data/"; then
    echo ""
    echo "**************"
    echo "* PostgreSQL *"
    echo "**************"
    echo ""

    cd ${BACKUP_DIR}/postgresql

    latestTerrama2BackupFile=$(basename -s .tar.gz $(ls -t1 | head -n 1))
    
    echo ""
    echo "********************"
    echo "* Extracting dump  *"
    echo "********************"
    echo ""

    tar xvf ${latestTerrama2BackupFile}.tar.gz -C /var/lib/docker/volumes/terrama2_postgres_vol/_data/

    echo ""
    echo "****************************************************"
    echo "* Importing dump to database ${POSTGRES_DATABASE}  *"
    echo "****************************************************"
    echo ""

    docker exec -it terrama2_postgres bash -c "cd /var/lib/postgresql/data/;psql -a -U postgres -h localhost < ${latestTerrama2BackupFile}.sql"

    echo ""
    echo "******************"
    echo "* Removing dump  *"
    echo "******************"
    echo ""

    rm -vf /var/lib/docker/volumes/terrama2_postgres_vol/_data/${latestTerrama2BackupFile}.sql

if test -d "/var/lib/docker/volumes/${COMPOSE_PROJECT_NAME}_geoserver_vol/_data/"; then
    echo ""
    echo "*************"
    echo "* Geoserver *"
    echo "*************"

    cd ${BACKUP_DIR}/geoserver

    latestGeoserverBackupFile=$(ls -t1 | head -n 1)

    echo ""
    echo "*********************"
    echo "* Removing old data *"
    echo "*********************"
    echo ""

    rm -vrf /var/lib/docker/volumes/${COMPOSE_PROJECT_NAME}_geoserver_vol/_data/*

    echo ""
    echo "**************"
    echo "* Extracting *"
    echo "**************"
    echo ""

    tar xvf ${latestGeoserverBackupFile} -C /var/lib/docker/volumes/${COMPOSE_PROJECT_NAME}_geoserver_vol/_data/
fi
