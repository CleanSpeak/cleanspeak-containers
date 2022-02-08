#
# CleanSpeak Management Interface Dockerfile including the MySQL connector
#
# Note:
# -----------------------------------------------------------------------------
# The MySQL JDBC connector is not bundled with CleanSpeak due to the GPL
# license terms under which Oracle publishes this software.
#
# https://github.com/mysql/mysql-connector-j/blob/release/8.0/LICENSE
#
# Because of this restriction, the MySQL connector is downloaded at runtime
# to allow CleanSpeak to connect to a MySQL JDBC URL.
#
# Generally speaking downloading this jar at runtime works just fine. However
# if you have blocked outbound network access or are concerned with this
# external network dependency leading to possible failures during startup you
# may optionally download the jar ahead of time.
#
# During startup, if we identify the correct MySQL connector jar in the
# classpath the download attempt will be skipped.
#
# Re-packaging the CleanSpeak Docker image with the MySQL connector is one
# way of keeping this download from occurring at runtime.
#
# This file is provided as an example only.
# -----------------------------------------------------------------------------
#
# Build: (use any variation of the following)
#   > docker build -t cleanspeak/cleanspeak-management-interface-mysql:3.32.1 .
#   > docker build -t cleanspeak/cleanspeak-management-interface-mysql:latest .
#   > docker build --build-arg MYSQL_CONNECTOR_VERSION=8.0.21 -t cleanspeak/cleanspeak-management-interface-mysql:latest .
#
# Run:
#  > docker run -p 8011:8011 -it cleanspeak/cleanspeak-management-interface-mysql
#

FROM cleanspeak/cleanspeak-management-interface:3.32.1

# Do not change this version, this is the version that will be expected in the classpath at runtime.
ARG MYSQL_CONNECTOR_VERSION=8.0.21

ADD --chown=cleanspeak:cleanspeak https://files.fusionauth.io/mysql/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar /usr/local/cleanspeak/cleanspeak-management-interface/apache-tomcat/lib
