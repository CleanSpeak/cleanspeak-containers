# CleanSpeak Containers

Container definitions for docker, kubernetes, and whatever containers come next!

## Docker

### Docker Compose

See [docker-compose.yml](https://raw.githubusercontent.com/CleanSpeak/cleanspeak-containers/master/docker/docker-compose.yml)

Review our [Docker Install Guide](https://cleanspeak.com/docs/3.x/tech/installation-guide/docker) for additional assistance.

```bash
curl -o docker-compose.yml https://raw.githubusercontent.com/CleanSpeak/cleanspeak-containers/master/docker/cleanspeak/docker-compose.yml
curl -o .env https://raw.githubusercontent.com/CleanSpeak/cleanspeak-containers/master/docker/cleanspeak/.env
docker-compose up
```

### Docker Images

[![Dockerhub](https://img.shields.io/docker/v/cleanspeak/cleanspeak-app)](https://hub.docker.com/repository/docker/cleanspeak/cleanspeak-app)

```bash
docker pull cleanspeak/cleanspeak-app:latest
docker run -itp 8001:8001 cleanspeak/cleanspeak-app:latest
```

## Kubernetes

### Notice

The Kubernetes portion of this repository is community maintained; and is provided to assist in your deployment and management of FusionAuth. Use of
this software is not covered under the CleanSpeak license agreement and is provided "as is" without warranty.  https://cleanspeak.com/license

```
kubernetes
├── *
├── README.md
```

See the [Kubernetes README](https://github.com/CleanSpeak/cleanspeak-containers/tree/master/kubernetes)
