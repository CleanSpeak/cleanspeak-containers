#
# CleanSpeak App Dockerfile including the MySQL connector
#
# Note:
# -----------------------------------------------------------------------------
# The MySQL JDBC connector is not bundled with CleanSpeak due to the GPL
# license terms under which Oracle publishes this software.
#
# Because of this restriction, you will need to build a docker image for your
# use that contains the MySQL JDBC connector in order to connect to a MySQL
# database at runtime.

# Source: https://github.com/mysql/mysql-connector-j
# License: https://github.com/mysql/mysql-connector-j/blob/release/8.0/LICENSE
# Homepage: https://dev.mysql.com/doc/connector-j/8.0/en/
#
# If you choose to build a Docker image containing this connector, ensure you
# aware and in compliance with the license under which the MySQL JDBC connector
# is provided.
#
# This file is provided as an example only.
# -----------------------------------------------------------------------------
#
# Build:
#   > docker build -t cleanspeak/cleanspeak-app-mysql:4.0.1 .
#
# Run:
#  > docker run -p 8001:8001 -it cleanspeak/cleanspeak-app-mysql
#

FROM cleanspeak/cleanspeak-app:4.0.1
ADD --chown=cleanspeak:cleanspeak https://search.maven.org/remotecontent?filepath=com/mysql/mysql-connector-j/8.0.33/mysql-connector-j-8.0.33.jar /usr/local/cleanspeak/cleanspeak-app/lib
