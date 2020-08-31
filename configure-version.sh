#!/bin/bash

echo "****************************"
echo "* Configuring config files *"
echo "****************************"
echo ""

# To debug each command, uncomment next line
# set -x

# Expand variables defined in file ".env" to current script execution
if [ ! -e ".env" ]
then
      cp .env.example .env
fi
eval $(egrep -v '^#' .env | xargs)

for image in conf/terrama2_webapp_settings.json.in \
             conf/terrama2_webapp_db.json.in \
             conf/terrama2_webmonitor.json.in \
             terrama2/Dockerfile.in \
             webapp/Dockerfile.in \
             webmonitor/Dockerfile.in \
             satalertas/server/config.json.in \
             satalertas/server/Dockerfile.in \
             satalertas/client/config/environment.prod.ts.in \
             satalertas/server/geoserver-conf/config.json.in \
             satalertas/client/Dockerfile.in \
             satalertas/docker-compose.yml.in; do
  sed -r \
        -e 's!%%TERRAMA2_PROJECT_NAME%%!'"${TERRAMA2_PROJECT_NAME}"'!g' \
        -e 's!%%TERRAMA2_DOCKER_REGISTRY%%!'"${TERRAMA2_DOCKER_REGISTRY}"'!g' \
        -e 's!%%TERRAMA2_TAG%%!'"${TERRAMA2_TAG}"'!g' \
        -e 's!%%SATALERTAS_TAG%%!'"${SATALERTAS_TAG}"'!g' \
        -e 's!%%TERRAMA2_PROTOCOL%%!'"${TERRAMA2_PROTOCOL}"'!g' \
        -e 's!%%TERRAMA2_DNS%%!'"${TERRAMA2_DNS}"'!g' \
        -e 's!%%TERRAMA2_BASE_PATH%%!'"${TERRAMA2_BASE_PATH}"'!g' \
        -e 's!%%TERRAMA2_WEBAPP_ADDRESS%%!'"${TERRAMA2_WEBAPP_ADDRESS}"'!g' \
        -e 's!%%TERRAMA2_WEBMONITOR_ADDRESS%%!'"${TERRAMA2_WEBMONITOR_ADDRESS}"'!g' \
        -e 's!%%TERRAMA2_GEOSERVER_ADDRESS%%!'"${TERRAMA2_GEOSERVER_ADDRESS}"'!g' \
        -e 's!%%SATALERTAS_CLIENT_PORT%%!'"${SATALERTAS_CLIENT_PORT}"'!g' \
        -e 's!%%SATALERTAS_SERVER_PORT%%!'"${SATALERTAS_SERVER_PORT}"'!g' \
        -e 's!%%POSTGRES_DATABASE%%!'"${POSTGRES_DATABASE}"'!g' \
        -e 's!%%BACKUP_DIR%%!'"${BACKUP_DIR}"'!g' \
        -e 's!%%PUBLIC_URI%%!'"${PUBLIC_URI}"'!g' \
        -e 's!%%WEBMONITOR_BASE_PATH%%!'"${WEBMONITOR_BASE_PATH}"'!g' \
        -e 's!%%WEBAPP_BASE_PATH%%!'"${WEBAPP_BASE_PATH}"'!g' \
        -e 's!%%GEOSERVER_PORT%%!'"${GEOSERVER_PORT}"'!g' \
      "${image}" > "${image::-3}"
done