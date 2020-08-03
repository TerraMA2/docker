#!/bin/bash

echo "*******************"
echo "* Backup TerraMA² *"
echo "*******************"
echo ""

echo "**************"
echo "* PostgreSQL *"
echo "**************"
echo ""

eval $(egrep -v '^#' .env | xargs)

DATE=$(date +%d-%m-%Y-%H:%M)

if test -d "/var/lib/docker/volumes/terrama2_pg_vol/_data/"; then
    docker exec -it terrama2_pg bash -c "
        pg_dump -U postgres -h localhost -d ${POSTGRES_DATABASE} -n terrama2 -f /var/lib/postgresql/data/dump-terrama2-${DATE}.sql -v; \
        pg_dump -U postgres -h localhost -d ${POSTGRES_DATABASE} -n public -f /var/lib/postgresql/data/dump-public-${DATE}.sql -v; \
        pg_dump -U postgres -h localhost -d ${POSTGRES_DATABASE} -n alertas -f /var/lib/postgresql/data/dump-alertas-${DATE}.sql -v; \
        cd /var/lib/postgresql/data/; \
        tar cvf - dump-terrama2-${DATE}.sql | gzip -9 - > dump-terrama2-${DATE}.tar.gz; \
        tar cvf - dump-public-${DATE}.sql | gzip -9 - > dump-public-${DATE}.tar.gz; \
        tar cvf - dump-alertas-${DATE}.sql | gzip -9 - > dump-alertas-${DATE}.tar.gz;
    "

    mkdir -p ${BACKUP_DIR}/postgresql

    mv /var/lib/docker/volumes/terrama2_pg_vol/_data/dump-public-${DATE}.tar.gz ${BACKUP_DIR}/postgresql
    mv /var/lib/docker/volumes/terrama2_pg_vol/_data/dump-terrama2-${DATE}.tar.gz ${BACKUP_DIR}/postgresql
fi

echo "*************"
echo "* Geoserver *"
echo "*************"
echo ""

if test -d "/var/lib/docker/volumes/${TERRAMA2_PROJECT_NAME}_geoserver_vol/_data/"; then
    mkdir -p ${BACKUP_DIR}/geoserver

    docker exec -it ${TERRAMA2_PROJECT_NAME}_geoserver bash -c "cd /opt/geoserver/data_dir;tar cvf - * | gzip -9 - > geoserver-${DATE}.tar.gz"

    mv /var/lib/docker/volumes/${TERRAMA2_PROJECT_NAME}_geoserver_vol/_data/geoserver-${DATE}.tar.gz ${BACKUP_DIR}/geoserver
fi

echo "**************"
echo "* SatAlertas *"
echo "**************"
echo ""

if test -d "/var/lib/docker/volumes/${TERRAMA2_PROJECT_NAME}_satalertas_documents_vol/_data/"; then
    mkdir -p ${BACKUP_DIR}/satalertas

    docker exec -it ${TERRAMA2_PROJECT_NAME}_satalertas_server_1 bash -c "cd documentos;tar cvf - *.pdf | gzip -9 - > satalertas_documents-${DATE}.tar.gz"

    mv /var/lib/docker/volumes/${TERRAMA2_PROJECT_NAME}_satalertas_documents_vol/_data/satalertas_documents-${DATE}.tar.gz ${BACKUP_DIR}/satalertas
fi