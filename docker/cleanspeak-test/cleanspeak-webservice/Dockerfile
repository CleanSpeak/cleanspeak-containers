FROM debian:stretch-slim

LABEL description="Container for CleanSpeak Webservice."
MAINTAINER CleanSpeak <dev@cleanspeak.com>

EXPOSE 8001

COPY cleanspeak-webservice_*.deb cleanspeak-webservice.deb

###### Install CleanSpeak Webservice #################
RUN dpkg -i cleanspeak-webservice.deb \
 && rm cleanspeak-webservice.deb

###### Start CleanSpeak Webservice ######################################
USER inversoft
CMD /usr/local/inversoft/cleanspeak-webservice/apache-tomcat/bin/catalina.sh run
