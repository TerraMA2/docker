#!/bin/bash

BACKUP_DIR="/data/backup"
CREATE_DB=0

usage() {
  MESSAGE=$1
  echo "Error: ${MESSAGE}"
  echo ""
  echo "Usage: backup [ -d | --database database ]
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

DATE=$(date +%d-%m-%Y-%H-%M)

echo ""
echo "*******************"
echo "* Backup TerraMA² *"
echo "*******************"
echo ""

if test -d "/var/lib/docker/volumes/terrama2_postgres_vol/_data/"; then
  PG_DUMP="pg_dump -f /var/lib/postgresql/data/dump-${DATE}.sql -h localhost -p 5432 -U postgres --quote-all-identifiers --no-password -v --role=postgres -Fp -b -c"
  if [ "$CREATE_DB" = 1 ]; then
    PG_DUMP="${PG_DUMP} -C"
  fi
  PG_DUMP="${PG_DUMP} ${DATABASE}"

  echo ""
  echo "**************"
  echo "* PostgreSQL *"
  echo "**************"

  echo ""
  echo "***********************************"
  echo "* Backing up database ${DATABASE} *"
  echo "***********************************"

  docker exec -it terrama2_postgres bash -c "${PG_DUMP}"

  mkdir -vp ${BACKUP_DIR}/${COMPOSE_PROJECT_NAME}/postgresql

  echo ""
  echo "********************"
  echo "* Compacting dumps *"
  echo "********************"

  cd /var/lib/docker/volumes/terrama2_postgres_vol/_data/ || exit

  tar cvf - dump-${DATE}.sql | gzip -9 - >${BACKUP_DIR}/${COMPOSE_PROJECT_NAME}/postgresql/dump-${DATE}.tar.gz

  rm -f dump-${DATE}.sql
fi

echo ""
echo "*************"
echo "* Geoserver *"
echo "*************"
echo ""

if test -d "/var/lib/docker/volumes/${COMPOSE_PROJECT_NAME}_geoserver_vol/_data/"; then
  mkdir -vp ${BACKUP_DIR}/${COMPOSE_PROJECT_NAME}/geoserver

  cd /var/lib/docker/volumes/${COMPOSE_PROJECT_NAME}_geoserver_vol/_data/ || exit

  tar cvf - * | gzip -9 - >${BACKUP_DIR}/${COMPOSE_PROJECT_NAME}/geoserver/geoserver-${DATE}.tar.gz
fi
