#!/bin/bash

# Initializing Services
service ssh start

# Forcing owner to ${TERRAMA2_USER} to Qtcreator be able to edit
chown -R ${TERRAMA2_USER}:${TERRAMA2_USER} /opt/terrama2/{build,codebase}

Xvfb -screen 0 1680x1024x16 -ac &

# Delay for Xvfb initialization
sleep 15

env DISPLAY=:0.0 x11vnc -noxrecord -noxfixes -noxdamage -forever -display :0 &
env DISPLAY=:0.0 fluxbox &

# Delay for GUI Server configuration
sleep 3

# Important to run as terrama2 user since this is debug image. The terrama2 services will be started by
# Qtcreator. In this case, a process is spawned by terrama2. Services started by root may cause permission problems in the future
# since the service may write in external volumes "/data" and "/shared-data". We must keep it safely. 
sudo -H -u ${TERRAMA2_USER} DISPLAY=:0.0 qtcreator &
# To run use "DISPLAY=:0.0 qtcreator"

bash