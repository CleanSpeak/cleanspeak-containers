

FROM debian:stretch-slim

LABEL description="Container for CleanSpeak Webservice."
MAINTAINER CleanSpeak <dev@cleanspeak.com>

EXPOSE 8001

###### Install stuff we need and then cleanup cache #################
RUN apt-get update && apt-get install -y --no-install-recommends \
 curl \
 && rm -rf /var/lib/apt/lists/*

###### Install CleanSpeak Webservice #################
ARG CLEANSPEAK_VERSION
RUN curl -Sk --progress-bar "https://storage.googleapis.com/inversoft_products_j098230498/products/cleanspeak/${CLEANSPEAK_VERSION}/cleanspeak-webservice_${CLEANSPEAK_VERSION}-1_all.deb" -o cleanspeak-webservice.deb \
 && dpkg -i cleanspeak-webservice.deb \
 && rm cleanspeak-webservice.deb

###### Start CleanSpeak Webservice ######################################
USER inversoft
CMD /usr/local/inversoft/cleanspeak-webservice/apache-tomcat/bin/catalina.sh run
