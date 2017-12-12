#!/bin/bash

cd $TERRAMA2_INSTALL_PATH/webapp

# Start Supervisorctl
service supervisor start

trap "supervisorctl stop terrama2-webapp" EXIT HUP INT QUIT TERM

# Lock Execution
supervisorctl tail -f terrama2-webapp
