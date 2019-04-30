#!/bin/bash

function is_valid() {
  local code=$1
  local err_msg=$2

  if [ $1 -ne 0 ]; then
    echo ${err_msg}
    exit ${code}
  fi
}

# Variables
_current_dir=${PWD}
eval $(egrep -v '^#' .env | xargs)

# GeoServer
cd geoserver
docker build --tag ${TERRAMA2_DOCKER_REGISTRY}/geoserver:2.11 . --rm
is_valid $? "Could not build GeoServer"

# TerraMA²
cd ${_current_dir}/terrama2

docker build --tag ${TERRAMA2_DOCKER_REGISTRY}/terrama2:${TERRAMA2_TAG} . --rm
is_valid $? "Could not build TerraMA² image"

# Webapp
cd ${_current_dir}/webapp

docker build --tag ${TERRAMA2_DOCKER_REGISTRY}/terrama2-webapp:${TERRAMA2_TAG} . --rm
is_valid $? "Could not build TerraMA² webapp image"

# Webmonitor
cd ${_current_dir}/webmonitor

docker build --tag ${TERRAMA2_DOCKER_REGISTRY}/terrama2-webmonitor:${TERRAMA2_TAG} . --rm
is_valid $? "Could not build TerraMA² webmonitor image"

# Bdqlight
cd ${_current_dir}/bdqueimadas-light

docker build --tag ${TERRAMA2_DOCKER_REGISTRY}/bdqlight:1.0.0 . --rm
is_valid $? "Could not build TerraMA² bdqlight image"
