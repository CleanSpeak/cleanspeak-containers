#!/bin/bash

VERSION=3.27.0

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

cd "$DIR" || (echo "Failed to change to the script directory" && exit 1)

cp "$HOME/dev/inversoft/cleanspeak/cleanspeak-management-interface/build/bundles/cleanspeak-management-interface_$VERSION-1_all.deb" cleanspeak-test/cleanspeak-management-interface
cp "$HOME/dev/inversoft/cleanspeak/cleanspeak-webservice/build/bundles/cleanspeak-webservice_$VERSION-1_all.deb" cleanspeak-test/cleanspeak-webservice

docker build -t cleanspeak/cleanspeak-management-interface:dev ./cleanspeak-test/cleanspeak-management-interface
docker build -t cleanspeak/cleanspeak-webservice:dev ./cleanspeak-test/cleanspeak-webservice
