#!/bin/bash

cd $BDQLIGHT_INSTALL_PATH

_TMA_EXEC_CODE=1

while [ ${_TMA_EXEC_CODE} -ne 0 ]
do
  npm start
  # Retrieve code execution
  _TMA_EXEC_CODE=$?

  # Delay to restart
  sleep 3
done
