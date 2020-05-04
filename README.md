# CleanSpeak Containers

Container definitions for docker, kubernetes, and whatever containers come next!

## Docker

### Docker Compose

See [docker-compose.yml](https://raw.githubusercontent.com/CleanSpeak/cleanspeak-containers/master/docker/docker-compose.yml)

Review our [Docker Install Guide](https://cleanspeak.com/docs/3.x/tech/installation-guide/docker) for additional assistance.

```bash
curl -o docker-compose.yml https://raw.githubusercontent.com/CleanSpeak/cleanspeak-containers/master/docker/docker-compose.yml
curl -o .env https://raw.githubusercontent.com/CleanSpeak/cleanspeak-containers/master/docker/.env
docker-compose up
```

### Docker Images

|   | Management Interface | Webservice |
|---| -------------------- | ---------- |
| Most recent version | [![Dockerhub](https://img.shields.io/docker/v/cleanspeak/cleanspeak-management-interface)](https://hub.docker.com/repository/docker/cleanspeak/cleanspeak-management-interface) | [![Dockerhub](https://img.shields.io/docker/v/cleanspeak/cleanspeak-webservice)](https://hub.docker.com/repository/docker/cleanspeak/cleanspeak-webservice) |

CleanSpeak Management Interface
```bash
docker pull cleanspeak/cleanspeak-management-interface:latest
docker run -itp 8011:8011 cleanseak/cleanspeak-management-interface:latest
```

CleanSpeak Webservice
```bash
docker pull cleanspeak/cleanspeak-webservice:latest
docker run -itp 8001:8001 cleanspeak/cleanspeak-webservice:latest
```

## Kubernetes

### Notice
The Kubernetes portion of this repository is community maintained; and is provided to assist in your deployment and management of FusionAuth. Use of this software is not covered under the CleanSpeak license agreement and is provided "as is" without warranty.  https://cleanspeak.com/license

```
kubernetes
├── *
├── README.md
```

See the [Kubernetes README](https://github.com/CleanSpeak/cleanspeak-containers/tree/master/kubernetes)
