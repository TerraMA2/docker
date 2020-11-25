FROM tomcat:8.0-jre8

# Port Bindind
EXPOSE 8080

# Customizable Variables

ENV GEOSERVER_URL "/geoserver"
ENV GEOSERVER_DATA_DIR /opt/geoserver/data_dir

# Install Geoserver and configure Tomcat

RUN mkdir -p $GEOSERVER_DATA_DIR && \
    wget --no-verbose -O geoserver-2.18.0-war.zip -L "https://sourceforge.net/projects/geoserver/files/GeoServer/2.18.0/geoserver-2.18.0-war.zip/download" && \
    unzip geoserver-2.18.0-war.zip && \
    mv geoserver.war /root/ && \
    rm geoserver-2.18.0-war.zip && \
    sed "125i<Context path=\"$GEOSERVER_URL\" docBase=\"/root/geoserver.war\"/>" /usr/local/tomcat/conf/server.xml > /root/server.xml && \
    mv /root/server.xml /usr/local/tomcat/conf/server.xml
    
COPY docker-entrypoint.sh /

ENTRYPOINT [ "/docker-entrypoint.sh" ]