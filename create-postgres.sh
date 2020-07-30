#!/bin/bash

docker volume create terrama2_pg_vol

docker run -d \
           --restart unless-stopped --name terrama2_pg \
           -p 127.0.0.1:5433:5432 \
           -v terrama2_pg_vol:/var/lib/postgresql/data \
           -e POSTGRES_PASSWORD=postgres \
           mdillon/postgis