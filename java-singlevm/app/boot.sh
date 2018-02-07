#!/bin/bash
set -euo pipefail

#Configure JAVA_OPTS
echo "JAVA_OPTS=\"-Djava.awt.headless=true -Xmx512m\"" >> /usr/share/tomcat/conf/tomcat.conf

exec "$@"
