#!/bin/bash

# Variables
_current_dir=${PWD}
eval $(egrep -v '^#' .env | xargs)

# TerraMA² SatAlertas server
docker push ${TERRAMA2_DOCKER_REGISTRY}/${TERRAMA2_PROJECT_NAME}-satalertas-server:${SATALERTAS_TAG}
_terrama2_satalertas_server_code=$?

# TerraMA² SatAlertas client
docker push ${TERRAMA2_DOCKER_REGISTRY}/${TERRAMA2_PROJECT_NAME}-satalertas-client:${SATALERTAS_TAG}
_terrama2_satalertas_client_code=$?

exit $(( ${_terrama2_satalertas_server_code} | ${_terrama2_satalertas_client_code} ))
