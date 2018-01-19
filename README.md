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
           -v terrama2_data_vol:/data \
           -v terrama2_shared_vol:/shared-data \
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

For more detailed instructions about environment variables, see the official documentation for the Postgres image [here](https://hub.docker.com/_/postgres/).

The above command will link the host address `127.0.0.1` on port `5433` to the container port `5432` and it will run the container as a daemon in background. You can try the following address in psql or pgAdmin:

```bash
psql -U postgres -p 5433 -h localhost -d postgres
```

In the above command use the password: `mysecretpassword`.

## Configure environment variables

Check and change (if necessary) the connection parameters located in file `.env`:

#### WebApp

| Variable | Description |
|----------|-------------|
| POSTGRESQL_DATABASE | PostgreSQL database name to use. Default `terrama2` |
POSTGRESQL_PASSWORD | PostgreSQL root password. |
POSTGRESQL_HOST | PostgreSQL host address. Default `terrama2_pg` |
POSTGRESQL_PORT | PostgreSQL port number. Default `5432` |
TERRAMA2_WEBAPP_BASE_PATH | Workdir for TerraMA² Webapp. Useful to proxy behind webserver. Default `/` |

#### WebMonitor

| Variable | Description |
|----------|-------------|
| POSTGRESQL_DATABASE | PostgreSQL database name to use. Default `terrama2` |
POSTGRESQL_PASSWORD | PostgreSQL root password. |
POSTGRESQL_HOST | PostgreSQL host address. Default `terrama2_pg` |
POSTGRESQL_PORT | PostgreSQL port number. Default `5432` |
TERRAMA2_WEBAPP_BASE_PATH | Workdir for TerraMA² Webapp. Useful to proxy behind webserver. Default `/`. |
| TERRAMA2_WEBMONITOR_BASE_PATH | Workdir for TerraMA² WebMonitor. Useful to proxy behind webserver. Default `/`. |

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

Create a new volume to store the BDQueimadas Light temporary download files:

```bash
docker volume create terrama2_bdq_vol
```

Pull the BDQueimadas Light image and run a new container named `terrama2_bdqlight`:

```bash
docker run -d \
           --restart unless-stopped --name terrama2_bdq \
           -p 127.0.0.1:39000:39000 \
           -v ${PWD}/conf/bdqueimadas-light/conf/:/opt/bdqueimadas-light/configurations/ \
           -v ${PWD}/conf/bdqueimadas-light/.pgpass:/root/.pgpass \
           -v ${PWD}/conf/terrama2_supervisor_bdqlight.conf:/etc/supervisor/conf.d/bdqueimadas-light.conf \
           -v terrama2_bdq_vol:/opt/bdqueimadas-light/tmp \
           terrama2.dpi.inpe.br:443/bdqlight:1.0.0
```

Link the BDqueimadas container in `terrama2_net`:

```bash
docker network connect terrama2_net terrama2_bdq
```

## Tips

Launching TerraMA² through docker-composer will name the containers with the suffix `_1`. You can connect to the docker container with:

```bash
docker exec -it terrama2_webapp_1 bash
```

## Developers

### Debug TerraMA² Service

If you want to debug a TerraMA² service, use the following commands:

```bash
docker run --detach \
           --interactive \
           --tty \
           --cap-add=SYS_PTRACE \
           --security-opt seccomp=unconfined \
           --name terrama2_debug \
           --volume acre_data_vol:/data \
           --volume terrama2_shared_data:/shared-data \
           --publish 5900:5900 \
           terrama2.dpi.inpe.br:443/terrama2:4.0.0-debug
```

We used special capabilities to the container `--cap-add=SYS_PTRACE` and `--security-opt seccomp=unconfined`. These flags are required, otherwise **gdb will not responding**.

Once container started, connect it in network:

```bash
docker network connect terrama2_net terrama2_debug
```

Now use a [VNC Client](https://en.wikipedia.org/wiki/Virtual_Network_Computing) to connect to the host `localhost:5900`

### Start TerraMA² instances

To start TerraMA² with GeoServer and PostgreSQL/PostGIS containers:

```bash
./terrama2_docker.sh up --project=terrama2 --with-geoserver=127.0.0.1:8081 --with-pg=127.0.0.1:5433
```

It will create GeoServer and PostgreSQL container binding respectively to host `127.0.0.1:8081` and `127.0.0.1:5433` using environment variables located in file `.env`.

To configure only TerraMA² instance (Make sure you have GeoServer and PostgreSQL running. Check Section **Check 3rd-party dependencies**):

```bash
./terrama2_docker.sh up --project=terrama2
```

To configure TerraMA² and PostgreSQL/PostGIS:

```bash
./terrama2_docker.sh up --project=terrama2 --with-pg=127.0.0.1:5433
```

To configure TerraMA² and GeoServer

```bash
./terrama2_docker.sh up --project=terrama2 --with-geoserver=127.0.0.1:8080
```

### Stop TerraMA² instances

Use the following command to stop active TerraMA² instances

```bash
# To stop only TerraMA² services
./terrama2_docker.sh stop --project=terrama2
```

You can also stop both PostgreSQL and GeoServer with the following command:

```bash
# To stop only TerraMA² services and PostgreSQL/PostGIS
./terrama2_docker.sh stop --project=terrama2 --with-pg --with-geoserver
```

### Remove TerraMA² instances

To remove containers: (`--with-geoserver` and `--with-pg` are optional)

```bash
# To stop only TerraMA² services and PostgreSQL/PostGIS
./terrama2_docker.sh rm --project=terrama2 --with-pg --with-geoserver
```

### Status of TerraMA² instances

Use the following command to check TerraMA² instances: (`--all` is optional)

```bash
# To stop only TerraMA² services, GeoServer and PostgreSQL/PostGIS
./terrama2_docker.sh status --project=terrama2 --all
```