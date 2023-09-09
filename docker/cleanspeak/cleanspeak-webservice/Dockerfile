#
# CleanSpeak Webservice Dockerfile
#
# Build:
#   > docker pull ubuntu:focal
#   > docker buildx build --platform=linux/arm64 -t cleanspeak/cleanspeak-webservice:3.32.0 .
#   > docker buildx build --platform=linux/arm64  -t fcleanspeak/cleanspeak-webservice:latest .
#
# Note: Substiture your target platform architecture. The above example is targetting a 64-bit ARM platform.
#       To target an Intel based platform use --platform=linux/amd64.
#
# Run:
#  > docker run -p 8001:8001 -it cleanspeak/cleanspeak-webservice
#
# Publish:
#   > docker push cleanspeak/cleanspeak-webservice:3.32.5
#   > docker push cleanspeak/cleanspeak-webservice:latest
#

###### Setup the java and fusionauth-app base #####################################################
FROM --platform=$BUILDPLATFORM ubuntu:focal as build

ARG BUILDPLATFORM
ARG CLEANSPEAK_VERSION=3.32.5
ARG JDK_MODULES=java.base,java.compiler,java.desktop,java.instrument,java.logging,java.management,java.naming,java.rmi,java.security.jgss,java.security.sasl,java.scripting,java.sql,java.xml.crypto,jdk.attach,jdk.crypto.ec,jdk.dynalink,jdk.jcmd,jdk.jdi,jdk.localedata,jdk.jpackage,jdk.unsupported,jdk.zipfs
ARG TARGETPLATFORM
ARG TARGETARCH
RUN printf "Building on ${BUILDPLATFORM} for ${TARGETPLATFORM} (${TARGETARCH})."
RUN case "${BUILDPLATFORM}" in \
    linux/arm64)\
        BUILD_JAVA_SUM="2e3c19c1707205c6b90cc04b416e8d83078ed98417d5a69dce3cf7dc0d7cfbca";\
        BUILD_JAVA_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.3%2B7/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.3_7.tar.gz";\
        ;;\
    linux/amd64)\
        BUILD_JAVA_SUM="81f5bed21077f9fbb04909b50391620c78b9a3c376593c0992934719c0de6b73";\
        BUILD_JAVA_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.3%2B7/OpenJDK17U-jdk_x64_linux_hotspot_17.0.3_7.tar.gz";\
        ;;\
    *)\
        printf "Unsupported build platform arch: ${BUILDPLATFORM}";\
        exit 1;\
        ;;\
    esac \
    && case "${TARGETARCH}" in \
    arm64)\
        JAVA_SUM="2e3c19c1707205c6b90cc04b416e8d83078ed98417d5a69dce3cf7dc0d7cfbca";\
        JAVA_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.3%2B7/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.3_7.tar.gz";\
        ;;\
    arm)\
        JAVA_SUM="d76c462f44c9f306a0fe4468a0218a261ab152f358a8fb55ec80865bf35e2c41";\
        JAVA_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.3%2B7/OpenJDK17U-jdk_arm_linux_hotspot_17.0.3_7.tar.gz";\
        ;;\
    ppc64le)\
        JAVA_SUM="a04587018c9719dca21073f19d56b335c4985f41afe7d99b24852c1a94b917e5";\
        JAVA_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.3%2B7/OpenJDK17U-jdk_ppc64le_linux_hotspot_17.0.3_7.tar.gz";\
        ;;\
    s390x)\
        JAVA_SUM="d9456cdf9719f9d8a11f26b2dd176cd6a8478d96ced09396765c7473482bc7f1";\
        JAVA_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.3%2B7/OpenJDK17U-jdk_s390x_linux_hotspot_17.0.3_7.tar.gz";\
        ;;\
    amd64)\
        JAVA_SUM="81f5bed21077f9fbb04909b50391620c78b9a3c376593c0992934719c0de6b73";\
        JAVA_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.3%2B7/OpenJDK17U-jdk_x64_linux_hotspot_17.0.3_7.tar.gz";\
        ;;\
    *)\
        printf "Unsupported arch: ${TARGETARCH}";\
        exit 1;\
        ;;\
    esac \
    && apt-get update \
    && apt-get install -y curl unzip \
    && mkdir -p /tmp/openjdk \
    && mkdir -p /tmp/build/openjdk \
    && curl -LfsSo /tmp/build/openjdk.tar.gz "${BUILD_JAVA_URL}" \
    && echo "${BUILD_JAVA_SUM} */tmp/build/openjdk.tar.gz" | sha256sum -c - \
    && curl -LfsSo /tmp/openjdk.tar.gz "${JAVA_URL}" \
    && echo "${JAVA_SUM} */tmp/openjdk.tar.gz" | sha256sum -c - \
    && cd /tmp/build/openjdk \
    && tar -xf /tmp/build/openjdk.tar.gz --strip-components=1 \
    && cd /tmp/openjdk \
    && tar -xf /tmp/openjdk.tar.gz --strip-components=1 \
    && /tmp/build/openjdk/bin/jlink --compress=2 \
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