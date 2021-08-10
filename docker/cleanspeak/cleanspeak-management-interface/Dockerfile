

FROM debian:stretch-slim

LABEL description="Container for CleanSpeak Management Interface."
MAINTAINER CleanSpeak <dev@cleanspeak.com>

EXPOSE 8011:8011

###### Install stuff we need and then cleanup cache #################
RUN apt-get update && apt-get install -y --no-install-recommends \
 curl \
 && rm -rf /var/lib/apt/lists/*

###### Install CleanSpeak Management Interface #################
ARG CLEANSPEAK_VERSION
RUN curl -Sk --progress-bar "https://files.fusionauth.io/products/cleanspeak/${CLEANSPEAK_VERSION}/cleanspeak-management-interface_${CLEANSPEAK_VERSION}-1_all.deb" -o cleanspeak-mi.deb \
 && dpkg -i cleanspeak-mi.deb \
 && rm cleanspeak-mi.deb

###### Start CleanSpeak Management Interface ######################################
USER inversoft
CMD /usr/local/inversoft/cleanspeak-management-interface/apache-tomcat/bin/catalina.sh run
