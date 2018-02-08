#!/bin/bash

# Catch errors and undefined variables
set -euo pipefail

# The directory where the app is installed
readonly installdir=/opt/app
# The user that should run the app
readonly system_user=bitnami

# Add bitnami user
useradd ${system_user}

# Uncompress application in /opt/app
tar xzf ${UPLOADS_DIR}/app.tar.gz -C /opt

# Set permissions
chown -R ${system_user}:${system_user} ${installdir}
