#!/bin/bash

BACKUP_DIR="/data/backup"
CREATE_DB=0

usage() {
  MESSAGE=$1
  echo "Error: ${MESSAGE}"
  echo ""
  echo "Usage: restore [ -d | --database database ]
              [ -B | --backup-dir directory ]
              [ -p | --project project ]
              [ -C | --create-database ]"
  exit 2
}

PARSED_ARGUMENTS=$(getopt -a -n argument -o d:B:p:C --long database:,backup-dir:,project:,create-database -- "$@")

VALID_ARGUMENTS=$?

if [ "$VALID_ARGUMENTS" != "0" ]; then
  usage "No arguments passed"
fi

eval set -- "$PARSED_ARGUMENTS"
while :; do
  case "$1" in
  -d | --database)
    DATABASE="$2"
    shift 2
    ;;
  -B | --backup-dir)
    BACKUP_DIR="$2"
    shift 2
    ;;
  -p | --project)
    COMPOSE_PROJECT_NAME="$2"
    shift 2
    ;;
  -C | --create-database)
    CREATE_DB=1
    shift
    ;;
  --)
    shift
    break
    ;;
  *)
    echo "Opção $1 não reconhecida."
    usage
    ;;
  esac
done

if [ ! "$DATABASE" ]; then
  usage "Database not specified"
fi

if [ ! "$COMPOSE_PROJECT_NAME" ]; then
  usage "Project not specified"
fi

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

    cd ${BACKUP_DIR}/${COMPOSE_PROJECT_NAME}/postgresql || exit

    latestTerrama2BackupFile=$(basename -s .tar.gz $(ls -t1 | head -n 1))
    
    echo ""
    echo "********************"
    echo "* Extracting dump  *"
    echo "********************"
    echo ""

    tar xvf ${latestTerrama2BackupFile}.tar.gz -C /var/lib/docker/volumes/terrama2_postgres_vol/_data/

    echo ""
    echo "******************************************"
    echo "* Importing dump to database ${DATABASE} *"
    echo "******************************************"
    echo ""

    PSQL="cd /var/lib/postgresql/data/;psql -a -U postgres -h localhost"
    if [ "$CREATE_DB" = 0 ]; then
      PSQL="${PSQL} ${DATABASE}"
    fi
    PSQL="${PSQL} < ${latestTerrama2BackupFile}.sql"

    docker exec -it terrama2_postgres bash -c "${PSQL}"

    echo ""
    echo "******************"
    echo "* Removing dump  *"
    echo "******************"
    echo ""

    rm -vf /var/lib/docker/volumes/terrama2_postgres_vol/_data/${latestTerrama2BackupFile}.sql
fi

if test -d "/var/lib/docker/volumes/${COMPOSE_PROJECT_NAME}_geoserver_vol/_data/"; then
    echo ""
    echo "*************"
    echo "* Geoserver *"
    echo "*************"

    cd ${BACKUP_DIR}/geoserver || exit

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
