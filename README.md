# Dockerfiles Repository for the TerraMA² Platform

## Cloning docker scripts for  TerraMA² Platform

```bash
git clone https://github.com/terrama2/docker.git
```

```bash
cd docker
```

## Check 3rd-party dependencies

### GeoServer

If you don't have a running version of GeoServer or you want to try an experimental version, you can use the built-in TerraMA² GeoServer image.

Log in the TerraMA² docker registry:

```bash
docker login terrama2.dpi.inpe.br:443
```

Create a new volume to store the GeoServer data files:

```bash
docker volume create terrama2_geoserver_vol
```

Pull the GeoServer image and run a new container named `terrama2_geoserver`:

```bash
docker run -d \
           --restart unless-stopped --name terrama2_geoserver \
           -p 127.0.0.1:8081:8080 \
           -e "GEOSERVER_URL=/geoserver" \
           -e "GEOSERVER_DATA_DIR=/opt/geoserver/data_dir" \
           -v terrama2_geoserver_vol:/opt/geoserver/data_dir \
           -v ${PWD}/conf/terrama2_geoserver_setenv.sh:/usr/local/tomcat/bin/setenv.sh \
           terrama2.dpi.inpe.br:443/geoserver:2.11
```

The above command will link the host address `127.0.0.1` on port `8081` to the container port `8080` and it will run the container as a daemon in background. You can try the following address in your browser: [http://localhost:8081/geoserver](http://localhost:8081/geoserver).

### PostgreSQL + PostGIS

If you don't have a running version of PostgreSQL with the PostGIS extension or you want to try an experimental version, you can use the image prepared by `mdillon/postgis`.

Create a new volume to store the PostgreSQL data files:

```bash
docker volume create terrama2_pg_vol
```

Pull the PostgreSQL image and run a new container named `terrama2_pg`:

```bash
docker run -d \
           --restart unless-stopped --name terrama2_pg \
           -p 127.0.0.1:5433:5432 \
           -v terrama2_pg_vol:/var/lib/postgresql/data \
           -e POSTGRES_PASSWORD=mysecretpassword \
           mdillon/postgis
```

The above command will link the host address `127.0.0.1` on port `5433` to the container port `5432` and it will run the container as a daemon in background. You can try the following address in psql or pgAdmin:

```bash
psql -U postgres -p 5433 -h localhost -d postgres
```

In the above command use the password: `mysecretpassword`.

## Running TerraMA²

In order to link all the peaces of TerraMA², you can create a network named `terrama2_net`:

```bash
docker network create terrama2_net
```

If you have installed the GeoServer and PostgreSQL as docker containers, as explained in above sections, link them together:

```bash
docker network connect terrama2_net terrama2_geoserver
docker network connect terrama2_net terrama2_pg
```

Now run the docker-compose in daemon mode:

```bash
docker-compose -p terrama2 up -d
```

If you want to check TerraMA² log output:

```bash
docker-compose -p terrama2 logs --follow
```

If you want to stop the TerraMA² containers:

```bash
docker-compose -p terrama2 stop
```

If you want to remove all the stopped containers:

```bash
docker-compose -p terrama2 rm
```

### BDQueimadas Light

In order to link all the peaces of BDQueimadas Light, you can create a network named `bdqlight_net`:

```bash
docker network create bdqlight_net
```

If you have installed the GeoServer and PostgreSQL as docker containers, as explained in above sections, link them together:

```bash
docker network connect bdqlight_net terrama2_geoserver
docker network connect bdqlight_net terrama2_pg
```

Pull the BDQueimadas Light image and run a new container named `terrama2_bdqlight`:

```bash
docker run -d \
           --restart unless-stopped --name terrama2_bdqlight \
           -p 127.0.0.1:39000:39000 \
           -v ${PWD}/conf/bdqueimadas-light/:/opt/bdqueimadas-light/configurations/ \
           terrama2.dpi.inpe.br:443/bdqlight:1.0.0
```

## Tips

Launching TerraMA² through docker-composer will name the containers with the suffix `_1`. You can connect to the docker container with:

```bash
docker exec -it terrama2_webapp_1 bash
```
