#!/bin/bash

set -x

# Start Services
sudo service ssh start

# Arguments
TERRAMA2_SERVICE_TYPE=$1
TERRAMA2_SERVICE_PORT=$2

echo "TerraMA² Service Type : $TERRAMA2_SERVICE_TYPE"
echo "TerraMA² Service Version : $TERRAMA2_SERVICE_PORT"

cd $TERRAMA2_INSTALL_PATH

# Lock Session
bash
