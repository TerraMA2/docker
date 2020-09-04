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

# Variables
_current_dir=${PWD}
eval $(egrep -v '^#' .env | xargs)

# SatAlertas server
cd ${_current_dir}/satalertas/server
docker build --tag ${TERRAMA2_DOCKER_REGISTRY}/${COMPOSE_PROJECT_NAME}-satalertas-server:${SATALERTAS_TAG} . --rm --no-cache
is_valid $? "Could not build SatAlertas server image"

# SatAlertas client
cd ${_current_dir}/satalertas/client
docker build --tag ${TERRAMA2_DOCKER_REGISTRY}/${COMPOSE_PROJECT_NAME}-satalertas-client:${SATALERTAS_TAG} . --rm --no-cache
is_valid $? "Could not build SatAlertas client image"