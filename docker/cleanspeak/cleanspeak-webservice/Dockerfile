#
# CleanSpeak Webservice Dockerfile
#
# Build:
#   > docker pull ubuntu:focal
#   > docker build -t cleanspeak/cleanspeak-webservice:3.32.0 .
#   > docker build -t cleanspeak/cleanspeak-webservice:latest .
#
# Run:
#  > docker run -p 8001:8001 -it cleanspeak/cleanspeak-webservice
#
# Publish:
#   > docker push cleanspeak/cleanspeak-webservice:3.32.0
#   > docker push cleanspeak/cleanspeak-webservice:latest
#

###### Setup the java and fusionauth-app base #####################################################
FROM ubuntu:focal as build

ARG CLEANSPEAK_VERSION=3.32.0
ARG JDK_MODULES=java.base,java.compiler,java.desktop,java.instrument,java.management,java.naming,java.rmi,java.security.jgss,java.security.sasl,java.sql,java.xml.crypto,jdk.attach,jdk.crypto.ec,jdk.jdi,jdk.localedata,jdk.zipfs
RUN ARCH="$(dpkg --print-architecture)"; \
    case "${ARCH}" in \
    aarch64|arm64)\
        ESUM='e08e6d8c84da28a2c49ccd511f8835c329fbdd8e4faff662c58fa24cca74021d';\
        BINARY_URL='https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17%2B35/OpenJDK17-jdk_aarch64_linux_hotspot_17_35.tar.gz';\
        ;;\
    armhf|armv7l|armel)\
        ESUM='77ef6aa6f665373e212097b937c22d0cad2add90e439ec0e90534a7ff0e8a6e9';\
        BINARY_URL='https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17%2B35/OpenJDK17-jdk_arm_linux_hotspot_17_35.tar.gz';\
        ;;\
    ppc64el|ppc64le)\
        ESUM='2e58f76fd332b73f323e47c73d0a81b76739debab067e7a32ed6abd73fd64c57';\
        BINARY_URL='https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17%2B35/OpenJDK17-jdk_ppc64le_linux_hotspot_17_35.tar.gz';\
        ;;\
    s390x)\
        ESUM='7a48159fca62b7f6afd58fb2e9712a3ef1494950212d4631e25598b45d9599b1';\
        BINARY_URL='https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17%2B35/OpenJDK17-jdk_s390x_linux_hotspot_17_35.tar.gz';\
        ;;\
    amd64|x86_64)\
        ESUM='6f1335d9a7855159f982dac557420397be9aa85f3f7bc84e111d25871c02c0c7';\
        BINARY_URL='https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17%2B35/OpenJDK17-jdk_x64_linux_hotspot_17_35.tar.gz';\
        ;;\
    *)\
        echo "Unsupported arch: ${ARCH}";\
        exit 1;\
        ;;\
    esac \
    && apt-get update \
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
     && curl -LfsSo /tmp/cleanspeak-webservice.zip https://files.fusionauth.io/products/cleanspeak/${CLEANSPEAK_VERSION}/cleanspeak-webservice-${CLEANSPEAK_VERSION}.zip \
     && mkdir -p /usr/local/cleanspeak/cleanspeak-webservice \
     && unzip -nq /tmp/cleanspeak-webservice.zip -d /usr/local/cleanspeak

###### Use Ubuntu latest and only copy in what we need to reduce the layer size ###################
FROM ubuntu:focal
RUN useradd -d /usr/local/cleanspeak -U cleanspeak
COPY --from=build /opt/openjdk /opt/openjdk
COPY --chown=cleanspeak:cleanspeak --from=build /usr/local/cleanspeak /usr/local/cleanspeak

###### Connect the log file to stdout #############################################################
RUN mkdir -p /usr/local/cleanspeak/logs \
  && touch /usr/local/cleanspeak/logs/cleanspeak-webservice.log \
  && ln -sf /dev/stdout /usr/local/cleanspeak/logs/cleanspeak-webservice.log

###### Start FusionAuth App #######################################################################
LABEL description="Create an image running CleanSpeak Webservice. Installs CleanSpeak Webservice"
LABEL maintainer="CleanSpeak <dev@cleanspeak.com>"
EXPOSE 8011
USER cleanspeak
ENV CLEANSPEAK_USE_GLOBAL_JAVA=1
ENV JAVA_HOME=/opt/openjdk
ENV PATH=$PATH:$JAVA_HOME/bin
CMD ["/usr/local/cleanspeak/cleanspeak-webservice/apache-tomcat/bin/catalina.sh", "run"]