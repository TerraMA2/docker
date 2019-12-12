#!/bin/bash

# To debug each command, uncomment next line
# set -x

# Expand variables defined in file ".env" to current script execution
eval $(egrep -v '^#' .env | xargs)

for image in terrama2/Dockerfile.in \
             webapp/Dockerfile.in \
             webmonitor/Dockerfile.in \
             conf/terrama2_webapp_settings.json.in; do
  sed -r \
        -e 's!%%TERRAMA2_TAG%%!'"${TERRAMA2_TAG}"'!g' \
        -e 's!%%TERRAMA2_DOCKER_REGISTRY%%!'"${TERRAMA2_DOCKER_REGISTRY}"'!g' \
      "${image}" > "${image::-3}"
done
