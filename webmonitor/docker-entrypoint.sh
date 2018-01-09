#!/bin/bash

cd ${TERRAMA2_INSTALL_PATH}/webmonitor

function replace_line_to() {
  local line=$1
  local value=$2
  local pattern=".*"

  echo "${line}s/${pattern}/${value}/"

  sed -i "${line}s/${pattern}/${value}/" config/instances/default.json
}

TERRAMA2_LOCK_FILE="/tmp/.terrama2.webmonitor.lock"

#
# Lock file to identify first run of TerraMA² WebApp image and then pre-configure initialization script.
#
if [ ! -e "${TERRAMA2_LOCK_FILE}" ]; then
  touch ${TERRAMA2_LOCK_FILE}

  echo "[program:terrama2-webmonitor]
directory=${TERRAMA2_INSTALL_PATH}/webmonitor
command=npm start
autostart=true
stderr_logfile=/var/log/terrama2-webmonitor-server.err.log
stdout_logfile=/var/log/terrama2-webmonitor-server.out.log" > /etc/supervisor/conf.d/terrama2-webmonitor.conf

  if [ -z "${TERRAMA2_WEBAPP_BASE_PATH}" ]; then
    TERRAMA2_WEBAPP_BASE_PATH="\/"
  fi

  if [ -z "${TERRAMA2_WEBAPP_HOST}" ]; then
    TERRAMA2_WEBAPP_HOST="localhost"
  fi

  if [ -z "${TERRAMA2_WEBAPP_PORT}" ]; then
    TERRAMA2_WEBAPP_PORT=36000
  fi

  if [ -z "${TERRAMA2_WEBMONITOR_BASE_PATH}" ]; then
    TERRAMA2_WEBMONITOR_BASE_PATH="\/"
  fi

  if [ -z "${POSTGRESQL_PORT}" ]; then
    POSTGRESQL_PORT=5432
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

  # Replace values in JSON
  replace_line_to 3 "\"basePath\": \"${TERRAMA2_WEBMONITOR_BASE_PATH}\","
  replace_line_to 8 "\"basePath\": \"${TERRAMA2_WEBAPP_BASE_PATH}\","
  replace_line_to 9 "\"port\": ${TERRAMA2_WEBAPP_PORT},"
  replace_line_to 10 "\"host\": \"${TERRAMA2_WEBAPP_HOST}\""

  echo "${POSTGRESQL_HOST}:${POSTGRESQL_PORT}:${POSTGRESQL_DATABASE}:${POSTGRESQL_USER}:${POSTGRESQL_PASSWORD}" | tee -a /root/.pgpass /home/${TERRAMA2_USER}/.pgpass
fi

# Start Supervisor
service supervisor start

trap "supervisorctl stop terrama2-webmonitor" EXIT HUP INT QUIT TERM

# Lock Execution
supervisorctl tail -f terrama2-webmonitor
