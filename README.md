# Dockerfiles Repository for the TerraMA² Platform

## Requirements

- [Docker](https://docs.docker.com/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Cloning docker scripts for  TerraMA² Platform

```bash
git clone https://github.com/terrama2/docker.git
```

```bash
cd docker
```

## Check 3rd-party dependencies

Create a volume `terrama2_shared_vol`:

```bash
docker volume create terrama2_shared_vol
```

### GeoServer

If you don't have a running version of GeoServer or you want to try an experimental version, you can use the built-in TerraMA² GeoServer image.

Create a new volume to store the GeoServer data files:

```bash
docker volume create terrama2_geoserver_vol
```

Pull the GeoServer image and run a new container named `terrama2_geoserver`:

```bash
docker run -d \
           --restart unless-stopped --name terrama2_geoserver \
           -p 127.0.0.1:8080:8080 \
           -e "GEOSERVER_URL=/geoserver" \
           -e "GEOSERVER_DATA_DIR=/opt/geoserver/data_dir" \
           -v terrama2_data_vol:/data \
           -v terrama2_shared_vol:/shared-data \
           -v terrama2_geoserver_vol:/opt/geoserver/data_dir \
           -v ${PWD}/conf/terrama2_geoserver_setenv.sh:/usr/local/tomcat/bin/setenv.sh \
           terrama2/geoserver:2.11
```

The above command will link the host address `127.0.0.1` on port `8080` to the container port `8080` and it will run the container as a daemon in background. You can try the following address in your browser: [http://localhost:8080/geoserver](http://localhost:8080/geoserver).

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

In order to link all the pieces of TerraMA², you can create a network named `terrama2_net`:

```bash
docker network create terrama2_net
```

If you have installed the GeoServer and PostgreSQL as docker containers, as explained in above sections, link them together:

```bash
docker network connect terrama2_net terrama2_geoserver
docker network connect terrama2_net terrama2_pg
```

Edit the file `conf/terrama2_webapp_db.json` with database credentials.

After that, configure files version properly:

```bash
./configure-version.sh
```

This command will generate **conf/terrama2_webapp.json** file. You may edit this file for connection parameters.

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

You can proceed to next post installation steps in [`link`](./README.md#post-installation-tips).

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
           -v terrama2_bdq_vol:/opt/bdqueimadas-light/tmp \
           terrama2/bdqlight:1.0.0
```

Link the BDqueimadas container in `terrama2_net`:

```bash
docker network connect terrama2_net terrama2_bdq
```

## Post Installation Tips

### Run TerraMA² localhost

#### Unix

On unix environment, add in the file `/etc/hosts` with following statements:

```
127.0.0.1       terrama2_geoserver
127.0.0.1       terrama2_webapp_1
127.0.0.1       terrama2_webmonitor_1
```

#### Windows

Open NotePad with Adminiistrator and then modifify the file `C:\Windows\System32\Drivers\etc\hosts`:

```
127.0.0.1       terrama2_geoserver
127.0.0.1       terrama2_webapp_1
127.0.0.1       terrama2_webmonitor_1
```

### Services

We must configure service parameters in [`Web Application`](http://127.0.0.1:36000) to associate with respective container.
On service hosts, unmark the option `Local Service` and then set the respective container name to the service at `Host Address`. For example, in the service `Local Collector`, use address `terrama2_collector_1`. For `Local Analysis`, use `terrama2_analysis_1` and so on.

When registering `Local View`, make sure that you have configured the directive provided on section `Run TerraMA² localhost` and specify the `Maps Server URL` with `terrama2_geoserver`.


## Tips

Launching TerraMA² through docker-composer will name the containers with the suffix `_1`. You can connect to the docker container with:

```bash
docker exec -it terrama2_webapp_1 bash
```