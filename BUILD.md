# Building TerraMA² Docker Images


## Cloning docker scripts for  TerraMA² Platform

```bash
git clone https://github.com/terrama2/docker.git
```


## Building the TerraMA² Docker Image

Go to the folder `terrama2`. It contains the `Dockerfile` to build the base image:

```bash
cd docker/terrama2
```

In that folder run the following command:

```bash
docker build --tag terrama2.dpi.inpe.br:443/terrama2:4.0.0 .
```

After building the base image you should build the `terrama2-webapp` and `terrama2-webmonitor` images:

```bash
cd docker/webapp
```

```bash
docker build --tag terrama2.dpi.inpe.br:443/terrama2-webapp:4.0.0 .
```

```bash
cd docker/webmonitor
```

```bash
docker build --tag terrama2.dpi.inpe.br:443/terrama2-webmonitor:4.0.0 .
```


## Publishing the Generated TerraMA² Images in a Private Registry

```bash
docker login terrama2.dpi.inpe.br:443
```

```bash
docker push terrama2.dpi.inpe.br:443/terrama2:4.0.0
```

```bash
docker push terrama2.dpi.inpe.br:443/terrama2-webapp:4.0.0
```

```bash
docker push terrama2.dpi.inpe.br:443/terrama2-webmonitor:4.0.0
```


## Tips

If you want to query the registry, type the following URL in your browser:

[https://terrama2.dpi.inpe.br/v2/_catalog](https://terrama2.dpi.inpe.br/v2/_catalog)

After all commands, try:
```bash
docker image prune
```