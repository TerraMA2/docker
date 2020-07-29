#!/bin/bash

echo "****************************"
echo "* Configuring config files *"
echo "****************************"
echo ""

# To debug each command, uncomment next line
# set -x

# Expand variables defined in file ".env" to current script execution
eval $(egrep -v '^#' .env | xargs)

for image in conf/terrama2_webapp_settings.json.in \
             conf/terrama2_webmonitor.json.in \
             conf/terrama2_webapp_db.json.in \
             terrama2/Dockerfile.in \
             webapp/Dockerfile.in \
             webmonitor/Dockerfile.in; do
  sed -r \
        -e 's!%%TERRAMA2_TAG%%!'"${TERRAMA2_TAG}"'!g' \
        -e 's!%%TERRAMA2_PROJECT_NAME%%!'"${TERRAMA2_PROJECT_NAME}"'!g' \
        -e 's!%%TERRAMA2_DOCKER_REGISTRY%%!'"${TERRAMA2_DOCKER_REGISTRY}"'!g' \
        -e 's!%%TERRAMA2_DNS%%!'"${TERRAMA2_DNS}"'!g' \
        -e 's!%%TERRAMA2_BASE_PATH%%!'"${TERRAMA2_BASE_PATH}"'!g' \
        -e 's!%%POSTGRES_DATABASE%%!'"${POSTGRES_DATABASE}"'!g' \
      "${image}" > "${image::-3}"
done
