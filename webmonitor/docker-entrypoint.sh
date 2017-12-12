#!/bin/bash

cd $TERRAMA2_INSTALL_PATH/webmonitor

# Start Supervisorctl
service supervisor start

trap "supervisorctl stop terrama2-webmonitor" EXIT HUP INT QUIT TERM

supervisorctl tail -f terrama2-webmonitor