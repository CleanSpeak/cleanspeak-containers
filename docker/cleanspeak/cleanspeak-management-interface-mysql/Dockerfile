#
# CleanSpeak Management Interface (with MySQL connector) Dockerfile
#
# Normally the mysql-connector jar is downloaded at runtime due to licensing,
# in this case the mysql connector jar will be baked into the image. As a result,
# this images CANNOT BE DISTRIBUTED due to the GPL license of the connector jar.
# We will only ship this file so that people can build the images themselves and
# thus avoid the license issues.
#
# Build: (use any variation of the following)
#   > docker build -t cleanspeak/cleanspeak-management-interface-mysql:1.16.0-RC.2 .
#   > docker build -t cleanspeak/cleanspeak-management-interface-mysql:latest .
#   > docker build --build-arg MYSQL_CONNECTOR_VERSION=8.0.18 -t cleanspeak/cleanspeak-management-interface-mysql:latest .
#
# Run:
#  > docker run -p 9011:9011 -it cleanspeak/cleanspeak-management-interface-mysql
#
# Publish:
#  DO NOT PUBLISH
#

FROM cleanspeak/cleanspeak-management-interface:latest

ARG MYSQL_CONNECTOR_VERSION=8.0.12

ADD --chown=inversoft:inversoft https://storage.googleapis.com/inversoft_products_j098230498/mysql/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar /usr/local/inversoft/cleanspeak-management-interface/apache-tomcat/lib
