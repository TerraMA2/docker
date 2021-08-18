#!/bin/bash

CURRENT_FOLDER=$(basename $(pwd))
if [ "$CURRENT_FOLDER" == 'scripts' ] ; then
  cd ..
fi

rm -rf conf/terrama2_webapp_db.json conf/terrama2_webapp_settings.json conf/terrama2_webmonitor.json terrama2/Dockerfile webapp/Dockerfile webmonitor/Dockerfile docker-compose.yml
