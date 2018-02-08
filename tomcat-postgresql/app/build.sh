#!/bin/bash

# Extra packages
# JDBC library for tomcat for enabling connections to a PostgreSQL database
yum install -y postgresql-jdbc && yum clean all && rm -fR /var/cache/yum

echo "=== FINISH BUILD SCRIPT ==="

