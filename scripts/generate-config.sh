#!/bin/bash

echo "****************************"
echo "* Configuring config files *"
echo "****************************"
echo ""

CURRENT_FOLDER=$(basename $(pwd))
if [ "$CURRENT_FOLDER" == 'scripts' ] ; then
  cd ..
fi

if [ ! -e ".env" ]; then
      cp .env.example .env
fi

eval $(egrep -v '^#' .env | xargs)

for file in conf/terrama2_webapp_settings.json.in \
             conf/terrama2_webapp_db.json.in \
             conf/terrama2_webmonitor.json.in \
             terrama2/Dockerfile.in \
             webapp/Dockerfile.in \
             docker-compose.yml.in \
             webmonitor/Dockerfile.in; do
  sed -r \
        -e 's!%%COMPOSE_PROJECT_NAME%%!'"${COMPOSE_PROJECT_NAME}"'!g' \
        -e 's!%%TERRAMA2_DOCKER_REGISTRY%%!'"${TERRAMA2_DOCKER_REGISTRY}"'!g' \
        -e 's!%%TERRAMA2_TAG%%!'"${TERRAMA2_TAG}"'!g' \
        -e 's!%%TERRAMA2_DATA_DIR%%!'"${TERRAMA2_DATA_DIR}"'!g' \
        -e 's!%%TERRAMA2_CONFIG_DIR%%!'"${TERRAMA2_CONFIG_DIR}"'!g' \
        -e 's!%%TERRAMA2_PROTOCOL%%!'"${TERRAMA2_PROTOCOL}"'!g' \
        -e 's!%%TERRAMA2_DNS%%!'"${TERRAMA2_DNS}"'!g' \
        -e 's!%%TERRAMA2_BASE_PATH%%!'"${TERRAMA2_BASE_PATH}"'!g' \
        -e 's!%%TERRAMA2_WEBAPP_ADDRESS%%!'"${TERRAMA2_WEBAPP_ADDRESS}"'!g' \
        -e 's!%%TERRAMA2_WEBMONITOR_ADDRESS%%!'"${TERRAMA2_WEBMONITOR_ADDRESS}"'!g' \
        -e 's!%%TERRAMA2_GEOSERVER_ADDRESS%%!'"${TERRAMA2_GEOSERVER_ADDRESS}"'!g' \
        -e 's!%%POSTGRES_DATABASE%%!'"${POSTGRES_DATABASE}"'!g' \
        -e 's!%%BACKUP_DIR%%!'"${BACKUP_DIR}"'!g' \
        -e 's!%%PUBLIC_URI%%!'"${PUBLIC_URI}"'!g' \
        -e 's!%%WEBMONITOR_BASE_PATH%%!'"${WEBMONITOR_BASE_PATH}"'!g' \
        -e 's!%%WEBAPP_BASE_PATH%%!'"${WEBAPP_BASE_PATH}"'!g' \
        -e 's!%%GEOSERVER_PORT%%!'"${GEOSERVER_PORT}"'!g' \
      "${file}" > "${file::-3}"
done
