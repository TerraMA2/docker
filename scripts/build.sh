#!/bin/bash

echo "******************************"
echo "* Building SatAlertas images *"
echo "******************************"
echo ""

function is_valid() {
  local code=$1
  local err_msg=$2

  if [ $1 -ne 0 ]; then
    echo ${err_msg}
    exit ${code}
  fi
}

CURRENT_FOLDER=$(basename $(pwd))
if [ "$CURRENT_FOLDER" == 'scripts' ] ; then
  cd ..
fi

eval $(egrep -v '^#' .env | xargs)

# GeoServer
# cd ${_current_dir}/geoserver
# docker build --tag ${TERRAMA2_DOCKER_REGISTRY}/geoserver:2.19.2 . --rm
# is_valid $? "Could not build GeoServer"

# TerraMA²
cd terrama2 || exit
docker build --tag ${TERRAMA2_DOCKER_REGISTRY}/terrama2:${TERRAMA2_TAG} . --rm
is_valid $? "Could not build TerraMA² image"

# Webapp
cd ../webapp || exit
docker build --tag ${TERRAMA2_DOCKER_REGISTRY}/terrama2-webapp:${TERRAMA2_TAG} . --rm
is_valid $? "Could not build TerraMA² webapp image"

# Webmonitor
cd ../webmonitor || exit
docker build --tag ${TERRAMA2_DOCKER_REGISTRY}/terrama2-webmonitor:${TERRAMA2_TAG} . --rm
is_valid $? "Could not build TerraMA² webmonitor image"
