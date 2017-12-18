#!/bin/bash

# Updating geoserver path
sed "125c<Context path=\"$GEOSERVER_URL\" docBase=\"/root/geoserver.war\"/>" /usr/local/tomcat/conf/server.xml > /root/server.xml
mv /root/server.xml /usr/local/tomcat/conf/server.xml

# Retrieving Tomcat GeoServer Folder
FOLDER_NAME="${GEOSERVER_URL//\//\#}"
GEO_ROOT_DIR="${PWD}/webapps/${FOLDER_NAME:1:100}"
PLUGINS_DIR="${GEO_ROOT_DIR}/WEB-INF/lib/"

# Configuring GeoServer Plugins
if [ ! -d "${PLUGINS_DIR}" ]; then
  # Unpack GeoServer.war in Tomcat Webapps folder
  unzip -d ${GEO_ROOT_DIR} /root/geoserver.war

  # Just download ImagePyramid Plugin if does not exist
  if [ ! -f "${PLUGINS_DIR}/gt-imagepyramid-17.0.jar" ]; then
    wget https://ufpr.dl.sourceforge.net/project/geoserver/GeoServer/2.11.0/extensions/geoserver-2.11.0-pyramid-plugin.zip
    unzip -d /tmp/_geoserver_docker geoserver-2.11.0-pyramid-plugin.zip
    mv /tmp/_geoserver_docker/gt-imagepyramid-17.0.jar ${PLUGINS_DIR}
    rm -rf /tmp/_geoserver_docker geoserver-2.11.0-pyramid-plugin.zip
  fi
fi

# Start Tomcat8
catalina.sh run