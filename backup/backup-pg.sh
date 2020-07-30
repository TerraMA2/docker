#!/bin/bash

docker exec -it terrama2_pg bash -c "pg_dumpall -U postgres -h localhost -f /var/lib/postgresql/data/dump.sql -v;cd /var/lib/postgresql/data/;tar cvf - dump.sql | gzip -9 - > dump.tar.gz"