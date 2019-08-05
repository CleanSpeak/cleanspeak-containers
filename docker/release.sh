#!/bin/bash

VERSION=3.24.1

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd "$DIR" || ( echo "Failed to change to the script directory" && exit 1)

docker build -t cleanspeak/cleanspeak-management-interface:$VERSION ./cleanspeak/cleanspeak-management-interface
docker build -t cleanspeak/cleanspeak-management-interface:latest ./cleanspeak/cleanspeak-management-interface
docker build -t cleanspeak/cleanspeak-webservice:$VERSION ./cleanspeak/cleanspeak-webservice
docker build -t cleanspeak/cleanspeak-webservice:latest ./cleanspeak/cleanspeak-webservice

docker push cleanspeak/cleanspeak-management-interface:$VERSION
docker push cleanspeak/cleanspeak-management-interface:latest
docker push cleanspeak/cleanspeak-webservice:$VERSION
docker push cleanspeak/cleanspeak-webservice:latest
