# docker
Dockerfiles Repository for the TerraMA² Platform

git clone https://github.com/terrama2/docker.git

cd docker

# GeoServer
docker login terrama2.dpi.inpe.br:443

docker volume create terrama2_geoserver_vol

docker run -d --restart unless-stopped -p 127.0.0.1:8081:8080 --name terrama2_geoserver -e "GEOSERVER_URL=/geoserver" -e "GEOSERVER_DATA_DIR=/opt/geoserver/data_dir" -v terrama2_geoserver_vol:/opt/geoserver/data_dir -v ${PWD}/conf/terrama2_geoserver_setenv.sh:/usr/local/tomcat/bin/setenv.sh terrama2.dpi.inpe.br:443/geoserver:2.11


# PostgreSQL + PostGIS

docker volume create terrama2_pg_vol

docker run --name terrama2_pg -p 127.0.0.1:5433:5432 -v terrama2_pg_vol:/var/lib/postgresql/data -e POSTGRES_PASSWORD=mysecretpassword -d mdillon/postgis


# TerraMA2

docker network create terrama2_net

docker network connect terrama2_net terrama2_geoserver
docker network connect terrama2_net terrama2_pg

docker-compose -p terrama2 up

CTRL + Z
bg

docker-compose -p terrama2 stop

docker-compose -p terrama2 rm
