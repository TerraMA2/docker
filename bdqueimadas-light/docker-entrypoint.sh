#!/bin/bash

cd $BDQLIGHT_INSTALL_PATH

# Start Supervisorctl
service supervisor start

trap "supervisorctl stop bdqueimadas-light" EXIT HUP INT QUIT TERM

# Lock Execution
supervisorctl tail -f bdqueimadas-light
