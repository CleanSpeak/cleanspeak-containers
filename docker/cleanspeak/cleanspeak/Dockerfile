#
# CleanSpeak App Dockerfile
#
# Build:
#   > docker buildx build --platform=linux/arm64 -t cleanspeak/cleanspeak-app:4.0.0 .
#
# Note: Substiture your target platform architecture. The above example is targetting a 64-bit ARM platform.
#       To target an Intel based platform use --platform=linux/amd64.
#
# Run:
#  > docker run -p 8001:8001 -it cleanspeak/cleanspeak-app
#
# Publish:
#   > docker push cleanspeak/cleanspeak-app:4.2.3
#

###### Setup the java and cleanspeak-app base #####################################################
# If you change the distro, test that weekly report PDF generation works first
FROM --platform=$BUILDPLATFORM ubuntu:noble AS build

ARG BUILDARCH
ARG BUILDPLATFORM
ARG CLEANSPEAK_VERSION=4.2.3
ARG JDK_MODULES=java.base,java.compiler,java.desktop,java.instrument,java.logging,java.management,java.naming,java.net.http,java.rmi,java.security.jgss,java.security.sasl,java.scripting,java.sql,java.xml.crypto,jdk.attach,jdk.crypto.ec,jdk.dynalink,jdk.jcmd,jdk.jdi,jdk.localedata,jdk.jpackage,jdk.unsupported,jdk.zipfs
ARG TARGETPLATFORM
ARG TARGETARCH
RUN printf "Building on ${BUILDPLATFORM} for ${TARGETPLATFORM} (${TARGETARCH})."
RUN --mount=type=bind,target=/ctx apt-get update \
    && apt-get install -y curl jq unzip \
    && JAVA_VERSION="$(jq -r '.version' /ctx/java.json)" \
    && JAVA_MAJOR=$(echo "${JAVA_VERSION}" | cut -d. -f1) \
    && echo "Using Java version ${JAVA_VERSION}" \
    && JAVA_VERSION_URL="jdk-$(echo "${JAVA_VERSION}" | sed 's/_/%2B/g')" \
    && BUILD_JAVA_SUM="$(jq -r '.checksums["'"${BUILDARCH}"'"]' /ctx/java.json)" \
    && BUILD_JAVA_URL="https://github.com/adoptium/temurin${JAVA_MAJOR}-binaries/releases/download/${JAVA_VERSION_URL}/OpenJDK${JAVA_MAJOR}U-jdk_$(echo "${BUILDPLATFORM}" | sed 's|linux/||;s|arm64|aarch64|;s|amd64|x64|')_linux_hotspot_${JAVA_VERSION}.tar.gz" \
    && JAVA_SUM="$(jq -r '.checksums["'"${TARGETARCH}"'"]' /ctx/java.json)" \
    && JAVA_URL="https://github.com/adoptium/temurin${JAVA_MAJOR}-binaries/releases/download/${JAVA_VERSION_URL}/OpenJDK${JAVA_MAJOR}U-jdk_$(echo "${TARGETARCH}" | sed 's|arm64|aarch64|;s|amd64|x64|')_linux_hotspot_${JAVA_VERSION}.tar.gz" \
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
    && if [ -f /ctx/cleanspeak-app-${CLEANSPEAK_VERSION}.zip ]; then \
             cp /ctx/cleanspeak-app-${CLEANSPEAK_VERSION}.zip /tmp/cleanspeak-app.zip; \
         else \
             curl -LfsSo /tmp/cleanspeak-app.zip https://files.fusionauth.io/products/cleanspeak/${CLEANSPEAK_VERSION}/cleanspeak-app-${CLEANSPEAK_VERSION}.zip; \
         fi \
     && mkdir -p /usr/local/cleanspeak/cleanspeak-app \
     && unzip -nq /tmp/cleanspeak-app.zip -d /usr/local/cleanspeak \
     && JAVA_DEB_VERSION="$(echo "${JAVA_VERSION}" | sed 's/_/+/')-99" \
     && DEB_TARGETARCH="${TARGETARCH}" \
     && if [ "${TARGETARCH}" = "ppc64le" ]; then DEB_TARGETARCH="ppc64el"; fi \
     && mkdir -p /tmp/jdk-shim/DEBIAN \
     && printf "Package: openjdk-${JAVA_MAJOR}-jdk\nSource: openjdk-${JAVA_MAJOR}\nVersion: ${JAVA_DEB_VERSION}\nArchitecture: ${DEB_TARGETARCH}\nMaintainer: Eclipse Adoptium <temurin@adoptium.net>\nDescription: Eclipse Temurin JDK ${JAVA_MAJOR} (security metadata shim)\n" \
             > /tmp/jdk-shim/DEBIAN/control \
     && dpkg-deb --build /tmp/jdk-shim /tmp/jdk-shim.deb \
     && rm -rf /tmp/jdk-shim

###### Use Ubuntu latest and only copy in what we need to reduce the layer size ###################
# If you change the distro, test that weekly report PDF generation works first
FROM ubuntu:noble
RUN apt-get update \
    && apt-get -y upgrade \
    # Automatically apply security updates that are currently available. some security updates (e.g. libssl3t64) \
    # will not apply after curl is installed \
    && apt-get -s dist-upgrade | grep "^Inst" | \
           grep -i securi | awk -F " " {'print $2'} | \
           xargs -r apt-get install -y \
    # fontconfig is needed by pdfbox (brings along libfreetype6) \
    # we want the lightest curl possible in the image (thus no-install-recommends) \
    && apt-get -y install --no-install-recommends curl fontconfig \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists \
    && useradd --shell /usr/sbin/nologin -d /usr/local/cleanspeak -U cleanspeak
COPY --from=build /opt/openjdk /opt/openjdk
COPY --chown=cleanspeak:cleanspeak --from=build /usr/local/cleanspeak /usr/local/cleanspeak
COPY --from=build /tmp/jdk-shim.deb /tmp/jdk-shim.deb

###### Connect the log file to stdout #############################################################
RUN mkdir -p /usr/local/cleanspeak/logs \
  && touch /usr/local/cleanspeak/logs/cleanspeak-app.log \
  && ln -sf /dev/stdout /usr/local/cleanspeak/logs/cleanspeak-app.log \
  && dpkg -i /tmp/jdk-shim.deb \
  && rm /tmp/jdk-shim.deb

###### Start CleanSpeak App #######################################################################
LABEL description="Create an image running CleanSpeak App. Installs CleanSpeak App"
LABEL maintainer="CleanSpeak <dev@cleanspeak.com>"
EXPOSE 8011
USER cleanspeak
ENV CLEANSPEAK_USE_GLOBAL_JAVA=1
ENV JAVA_HOME=/opt/openjdk
ENV PATH=$PATH:$JAVA_HOME/bin
CMD ["/usr/local/cleanspeak/cleanspeak-app/bin/start.sh"]
