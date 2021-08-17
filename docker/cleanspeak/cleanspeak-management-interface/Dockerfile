#
# CleanSpeak Management Interface Dockerfile
#
# Build:
#   > docker pull ubuntu:focal
#   > docker build -t cleanspeak/cleanspeak-management-interface:3.31.1 .
#   > docker build -t cleanspeak/cleanspeak-management-interface:latest .
#
# Run:
#  > docker run -p 8011:8011 -it cleanspeak/cleanspeak-management-interface
#
# Publish:
#   > docker push cleanspeak/cleanspeak-management-interface:3.31.1
#   > docker push cleanspeak/cleanspeak-management-interface:latest
#

###### Setup the java and fusionauth-app base #####################################################
FROM ubuntu:focal as build

ARG CLEANSPEAK_VERSION=3.31.1
ARG JDK_MODULES=java.base,java.compiler,java.desktop,java.instrument,java.management,java.naming,java.rmi,java.security.jgss,java.security.sasl,java.sql,java.xml.crypto,jdk.attach,jdk.crypto.ec,jdk.jdi,jdk.localedata,jdk.unsupported,jdk.zipfs
RUN ESUM='9ddf9b35996fbd784a53fff3e0d59920a7d5acf1a82d4c8d70906957ac146cd1';\
    BINARY_URL='https://github.com/AdoptOpenJDK/openjdk14-binaries/releases/download/jdk-14.0.1%2B7/OpenJDK14U-jdk_x64_linux_hotspot_14.0.1_7.tar.gz';\
    apt-get update \
    && apt-get install -y curl unzip \
    && curl -LfsSo /tmp/openjdk.tar.gz "${BINARY_URL}" \
    && echo "${ESUM} */tmp/openjdk.tar.gz" | sha256sum -c - \
    && mkdir -p /tmp/openjdk \
    && cd /tmp/openjdk \
    && tar -xf /tmp/openjdk.tar.gz --strip-components=1 \
    && /tmp/openjdk/bin/jlink --compress=2 \
       --module-path /tmp/openjdk/jmods/ \
       --add-modules ${JDK_MODULES} \
       --output /opt/openjdk \
     && curl -LfsSo /tmp/cleanspeak-management-interface.zip https://files.fusionauth.io/products/cleanspeak/${CLEANSPEAK_VERSION}/cleanspeak-management-interface-${CLEANSPEAK_VERSION}.zip \
     && mkdir -p /usr/local/cleanspeak/cleanspeak-management-interface \
     && unzip -nq /tmp/cleanspeak-management-interface.zip -d /usr/local/cleanspeak

###### Use Ubuntu latest and only copy in what we need to reduce the layer size ###################
FROM ubuntu:focal
RUN useradd -d /usr/local/cleanspeak -U cleanspeak
COPY --from=build /opt/openjdk /opt/openjdk
COPY --chown=cleanspeak:cleanspeak --from=build /usr/local/cleanspeak /usr/local/cleanspeak

###### Connect the log file to stdout #############################################################
RUN mkdir -p /usr/local/cleanspeak/logs \
  && touch /usr/local/cleanspeak/logs/cleanspeak-management-interface.log \
  && ln -sf /dev/stdout /usr/local/cleanspeak/logs/cleanspeak-management-interface.log

###### Start FusionAuth App #######################################################################
LABEL description="Create an image running CleanSpeak Management Interface. Installs CleanSpeak Management Interface"
LABEL maintainer="CleanSpeak <dev@cleanspeak.com>"
EXPOSE 8011
USER cleanspeak
ENV CLEANSPEAK_USE_GLOBAL_JAVA=1
ENV JAVA_HOME=/opt/openjdk
ENV PATH=$PATH:$JAVA_HOME/bin
CMD ["/usr/local/cleanspeak/cleanspeak-management-interface/apache-tomcat/bin/catalina.sh", "run"]