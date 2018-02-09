#!/bin/bash

set -euo pipefail
readonly database_conf_file=/var/www/html/config.php
readonly database_init_file=/var/www/html/data/init.sql
sed -i -e "s/DATABASE_HOST/\"${DATABASE_HOST}\"/" "${database_conf_file}"
sed -i -e "s/DATABASE_USER/\"${DATABASE_USER}\"/" "${database_conf_file}"
sed -i -e "s/DATABASE_NAME/\"${DATABASE_NAME}\"/" "${database_conf_file}"
sed -i -e "s/DATABASE_PASSWORD/\"${DATABASE_PASSWORD}\"/" "${database_conf_file}"
sed -i -e "s/DATABASE_NAME/${DATABASE_NAME}/" "${database_init_file}"

echo "=== DATABASE ENV VARS ==="
echo "DATABASE_HOST: ${DATABASE_HOST}"
echo "DATABASE_NAME: ${DATABASE_NAME}"
echo "DATABASE_USER: ${DATABASE_USER}"
echo "DATABASE_PASSWORD: ${DATABASE_PASSWORD}"
exec "$@"
