#!/bin/bash
echo ""
echo "********************"
echo "* Restore TerraMA² *"
echo "********************"

eval $(egrep -v '^#' .env | xargs)

if test -d "/var/lib/docker/volumes/terrama2_pg_vol/_data/"; then
    echo ""
    echo "**************"
    echo "* PostgreSQL *"
    echo "**************"
    echo ""

    cd ${BACKUP_DIR}/postgresql
    
    latestTerrama2BackupFile=$(basename -s .tar.gz $(ls -t1 | grep terrama2 | head -n 1))
    latestAlertasBackupFile=$(basename -s .tar.gz $(ls -t1 | grep alertas | head -n 1))
    latestPublicBackupFile=$(basename -s .tar.gz $(ls -t1 | grep public | head -n 1))

    echo ""
    echo "********************"
    echo "* Extracting dumps *"
    echo "********************"
    echo ""

    tar xvf ${latestTerrama2BackupFile}.tar.gz -C /var/lib/docker/volumes/terrama2_pg_vol/_data/
    tar xvf ${latestAlertasBackupFile}.tar.gz -C /var/lib/docker/volumes/terrama2_pg_vol/_data/
    tar xvf ${latestPublicBackupFile}.tar.gz -C /var/lib/docker/volumes/terrama2_pg_vol/_data/

    docker exec -it terrama2_pg bash -c "
        cd /var/lib/postgresql/data; \

        echo ""
        echo \"********************\"; \
        echo \"* Dropping schemas *\"; \
        echo \"********************\"; \
        echo \"\"; \

        psql -a -U postgres -h localhost -d ${POSTGRES_DATABASE} -c 'DROP SCHEMA terrama2 CASCADE'; \
        psql -a -U postgres -h localhost -d ${POSTGRES_DATABASE} -c 'DROP TABLE alertas.reports CASCADE;DROP TABLE alertas.SequelizeMeta CASCADE;DROP SCHEMA alertas CASCADE'; \
        psql -a -U postgres -h localhost -d ${POSTGRES_DATABASE} -c 'DROP SCHEMA public CASCADE'; \

        echo ""
        echo \"****************************************************\"; \
        echo \"* Importing dumps to database ${POSTGRES_DATABASE} *\"; \
        echo \"****************************************************\"; \
        echo \"\"; \

        echo ""
        echo \"*****************************\"; \
        echo \"* Importing schema terrama2 *\"; \
        echo \"*****************************\"; \
        echo \"\"; \

        psql -a -U postgres -h localhost -d ${POSTGRES_DATABASE} < ${latestTerrama2BackupFile}.sql; \

        echo ""
        echo \"****************************\"; \
        echo \"* Importing schema alertas *\"; \
        echo \"****************************\"; \
        echo \"\"; \

        psql -a -U postgres -h localhost -d ${POSTGRES_DATABASE} < ${latestAlertasBackupFile}.sql; \

        echo ""
        echo \"***************************\"; \
        echo \"* Importing schema public *\"; \
        echo \"***************************\"; \
        echo \"\"; \

        psql -a -U postgres -h localhost -d ${POSTGRES_DATABASE} < ${latestPublicBackupFile}.sql; \

        echo ""
        echo \"******************\"; \
        echo \"* Removing dumps *\"; \
        echo \"******************\"; \
        echo \"\"; \

        rm -vf ${latestTerrama2BackupFile}.sql; \
        rm -vf ${latestAlertasBackupFile}.sql; \
        rm -vf ${latestPublicBackupFile}.sql;
    "
fi

if test -d "/var/lib/docker/volumes/${TERRAMA2_PROJECT_NAME}_geoserver_vol/_data/"; then
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

    rm -vrf /var/lib/docker/volumes/${TERRAMA2_PROJECT_NAME}_geoserver_vol/_data/*

    echo ""
    echo "**************"
    echo "* Extracting *"
    echo "**************"
    echo ""

    tar xvf ${latestGeoserverBackupFile} -C /var/lib/docker/volumes/${TERRAMA2_PROJECT_NAME}_geoserver_vol/_data/
fi

if test -d "/var/lib/docker/volumes/${TERRAMA2_PROJECT_NAME}_satalertas_documents_vol/_data/"; then
    echo ""
    echo "**************"
    echo "* SatAlertas *"
    echo "**************"

    cd ${BACKUP_DIR}/satalertas

    latestDocumentBackupFile=$(ls -t1 | head -n 1)
    
    echo ""
    echo "*********************"
    echo "* Removing old data *"
    echo "*********************"
    echo ""

    rm -vrf /var/lib/docker/volumes/${TERRAMA2_PROJECT_NAME}_satalertas_documents_vol/_data/*

    echo ""
    echo "**************"
    echo "* Extracting *"
    echo "**************"
    echo ""

    tar xvf ${latestDocumentBackupFile} -C /var/lib/docker/volumes/${TERRAMA2_PROJECT_NAME}_satalertas_documents_vol/_data/
fi