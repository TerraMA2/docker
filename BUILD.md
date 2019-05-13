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

Configure **Dockerfiles** with respective version:

```bash
./configure-version.sh
```

After that, just run script **build-image.sh** to build:

```bash
./build-image.sh
```

## Publishing the Generated TerraMA² Images

```bash
docker push terrama2/terrama2:4.0.11
```

```bash
docker push terrama2/terrama2-webapp:4.0.11
```

```bash
docker push terrama2/terrama2-webmonitor:4.0.11
```


## Tips

If you want to query the registry, type the following URL in your browser:

[https://terrama2.dpi.inpe.br/v2/_catalog](https://terrama2.dpi.inpe.br/v2/_catalog)

After all commands, try:
```bash
docker image prune
```
