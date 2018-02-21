#!/bin/bash

cd ${TERRAMA2_INSTALL_PATH}/webapp

function write_to() {
  local pattern=$1
  local value=$2
  # "a" -> Append 
  # "c" -> Replace in current line
  local flag=$3

  sed -i "/${pattern}/${flag}\\${value}" config/instances/default.json
}

function normalize_url() {
  local url=$1
  local pattern="\\/"

  echo "${url//\//$pattern}"
}

TERRAMA2_LOCK_FILE="/tmp/.terrama2.webapp.lock"

#
# Lock file to identify first run of TerraMA² WebApp image and then pre-configure initialization script.
#
if [ ! -e "${TERRAMA2_LOCK_FILE}" ]; then
  touch ${TERRAMA2_LOCK_FILE}

  echo "[program:terrama2-webapp]
directory=${TERRAMA2_INSTALL_PATH}/webapp
command=npm start
autostart=true
stderr_logfile=/var/log/terrama2-webapp-server.err.log
stdout_logfile=/var/log/terrama2-webapp-server.out.log" > /etc/supervisor/conf.d/terrama2-webapp.conf

  if [ -z "${POSTGRESQL_PORT}" ]; then
    POSTGRESQL_PORT=5432
  fi

  if [ -z "${TERRAMA2_WEBAPP_BASE_PATH}" ]; then
    TERRAMA2_WEBAPP_BASE_PATH="/"
  fi

  TERRAMA2_WEBAPP_BASE_PATH=$(normalize_url ${TERRAMA2_WEBAPP_BASE_PATH})

  if [ -z "${TERRAMA2_DATA_DIR}" ]; then
    TERRAMA2_DATA_DIR="/data"
  fi

  if [ -z "${POSTGRESQL_USER}" ]; then
    POSTGRESQL_USER=postgres
  fi

  if [ -z "${POSTGRESQL_PASSWORD}" ]; then
    POSTGRESQL_PASSWORD=mysecretpassword
  fi

  if [ -z "${POSTGRESQL_DATABASE}" ]; then
    POSTGRESQL_DATABASE=terrama2
  fi

  if [ -z "${POSTGRESQL_HOST}" ]; then
    POSTGRESQL_HOST=terrama2_pg
  fi

  # Append Port after Database since the TerraMA² File does not contain db port (Use 5432).
  write_to "database" "\"port\": ${POSTGRESQL_PORT}," "a"

  # Replace values in JSON
  write_to "\"basePath\":" "\"basePath\": \"${TERRAMA2_WEBAPP_BASE_PATH}\"," "c"
  write_to "\"defaultFilePath\":" "\"defaultFilePath\": \"${TERRAMA2_DATA_DIR}\"," "c"
  write_to "\"username\":" "\"username\": \"${POSTGRESQL_USER}\"," "c"
  write_to "\"password\":" "\"password\": \"${POSTGRESQL_PASSWORD}\"," "c"
  write_to "\"database\":" "\"database\": \"${POSTGRESQL_DATABASE}\"," "c"
  write_to "\"host\":" "\"host\": \"${POSTGRESQL_HOST}\"," "c"

  echo "${POSTGRESQL_HOST}:${POSTGRESQL_PORT}:${POSTGRESQL_DATABASE}:${POSTGRESQL_USER}:${POSTGRESQL_PASSWORD}" | tee -a /root/.pgpass /home/${TERRAMA2_USER}/.pgpass >/dev/null
fi

# Start Supervisor
service supervisor start

trap "supervisorctl stop terrama2-webapp" EXIT HUP INT QUIT TERM

# Lock Execution
supervisorctl tail -f terrama2-webapp
