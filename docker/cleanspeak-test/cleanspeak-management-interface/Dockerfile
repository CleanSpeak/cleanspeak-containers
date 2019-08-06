FROM debian:stretch-slim

LABEL description="Container for CleanSpeak Management Interface."
MAINTAINER CleanSpeak <dev@cleanspeak.com>

EXPOSE 8001 8000

COPY cleanspeak-management-interface_*.deb cleanspeak-management-interface.deb

###### Install CleanSpeak Webservice #################
RUN dpkg -i cleanspeak-management-interface.deb \
 && rm cleanspeak-management-interface.deb

###### Start CleanSpeak Webservice ######################################
USER inversoft
ENV JPDA_ADDRESS=5005
CMD /usr/local/inversoft/cleanspeak-management-interface/apache-tomcat/bin/catalina.sh jpda run
