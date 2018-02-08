#!/bin/bash
set -euo pipefail

#Configure JAVA_OPTS
echo "JAVA_OPTS=\"-Djava.awt.headless=true -Xmx512m\"" >> /usr/share/tomcat/conf/tomcat.conf


# WARNING: the password will be shown in the logs. Remove it if you want to hide that password.
# You can use those env vars 
echo "=== DATABASE ENV VARS ==="
echo "DATABASE_HOST: ${DATABASE_HOST}"
echo "DATABASE_NAME: ${DATABASE_NAME}"
echo "DATABASE_USER: ${DATABASE_USER}"
echo "DATABASE_PASSWORD: ${DATABASE_PASSWORD}"

exec "$@"
