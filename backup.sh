#!/bin/bash

echo ""
echo "*******************"
echo "* Backup TerraMA² *"
echo "*******************"
echo ""

eval $(egrep -v '^#' .env | xargs)

DATE=$(date +%d-%m-%Y-%H-%M)

if test -d "/var/lib/docker/volumes/terrama2_pg_vol/_data/"; then
    echo ""
    echo "**************"
    echo "* PostgreSQL *"
    echo "**************"
    
    docker exec -it terrama2_pg bash -c "
        echo \"\"; \
        echo \"**************\"; \
        echo \"* Backing up *\"; \
        echo \"**************\"; \

        echo \"\"; \
        echo \"******************************\"; \
        echo \"* Backing up schema terrama2 *\"; \
        echo \"******************************\"; \
        echo \"\"; \

        pg_dump -U postgres -h localhost -d ${POSTGRES_DATABASE} -n terrama2 -f /var/lib/postgresql/data/dump-terrama2-${DATE}.sql -v; \

        echo \"\"; \
        echo \"****************************\"; \
        echo \"* Backing up schema public *\"; \
        echo \"****************************\"; \
        echo \"\"; \

        pg_dump -U postgres -h localhost -d ${POSTGRES_DATABASE} -n public -f /var/lib/postgresql/data/dump-public-${DATE}.sql -v; \

        echo \"\"; \
        echo \"*****************************\"; \
        echo \"* Backing up schema alertas *\"; \
        echo \"*****************************\"; \
        echo \"\"; \

        pg_dump -U postgres -h localhost -d ${POSTGRES_DATABASE} -n alertas -f /var/lib/postgresql/data/dump-alertas-${DATE}.sql -v
    "
    
    mkdir -vp ${BACKUP_DIR}/postgresql

    echo ""
    echo "********************"
    echo "* Compacting dumps *"
    echo "********************"

    cd /var/lib/docker/volumes/terrama2_pg_vol/_data/

    echo ""
    echo "***********************"
    echo "* Compacting terrama2 *"
    echo "***********************"
    echo ""

    tar cvf - dump-terrama2-${DATE}.sql | gzip -9 - > ${BACKUP_DIR}/postgresql/dump-terrama2-${DATE}.tar.gz

    echo ""
    echo "*********************"
    echo "* Compacting public *"
    echo "*********************"
    echo ""

    tar cvf - dump-public-${DATE}.sql | gzip -9 - > ${BACKUP_DIR}/postgresql/dump-public-${DATE}.tar.gz

    echo ""
    echo "**********************"
    echo "* Compacting alertas *"
    echo "**********************"
    echo ""

    tar cvf - dump-alertas-${DATE}.sql | gzip -9 - > ${BACKUP_DIR}/postgresql/dump-alertas-${DATE}.tar.gz
    
    rm -f dump-terrama2-${DATE}.sql
    rm -f dump-public-${DATE}.sql
    rm -f dump-alertas-${DATE}.sql
fi

echo ""
echo "*************"
echo "* Geoserver *"
echo "*************"
echo ""

if test -d "/var/lib/docker/volumes/${TERRAMA2_PROJECT_NAME}_geoserver_vol/_data/"; then
    mkdir -vp ${BACKUP_DIR}/geoserver

    cd /var/lib/docker/volumes/${TERRAMA2_PROJECT_NAME}_geoserver_vol/_data/

    tar cvf - * | gzip -9 - > ${BACKUP_DIR}/geoserver/geoserver-${DATE}.tar.gz
fi

echo ""
echo "**************"
echo "* SatAlertas *"
echo "**************"
echo ""

if test -d "/var/lib/docker/volumes/${TERRAMA2_PROJECT_NAME}_satalertas_documents_vol/_data/"; then
    mkdir -vp ${BACKUP_DIR}/satalertas

    cd /var/lib/docker/volumes/${TERRAMA2_PROJECT_NAME}_satalertas_documents_vol/_data/

    tar cvf - *.pdf | gzip -9 - > ${BACKUP_DIR}/satalertas/satalertas_documents-${DATE}.tar.gz
fi