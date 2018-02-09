#!/bin/bash

set -euo pipefail

readonly uploads_dir=${UPLOADS_DIR:?Uploads directory not provided. Please set the UPLOADS_DIR environment variable}


installDependencies() {
    yum install -y unzip
}

installTomcat() {
    yum install -y tomcat tomcat-jsvc
}

disableSELinux() {
    # permissive is equivalent to disable + logging
    sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config
}

deployWarFile() {
    local warfile
    warfile=${1:?No war file provided}

    local warfile_basename
    warfile_basename=$(basename "${warfile}")

    local app_name
    app_name=${warfile_basename%.*}

    mkdir /var/lib/tomcat/webapps/"${app_name}"
    unzip -q "${warfile}" -d /var/lib/tomcat/webapps/"${app_name}"
    chown -R root:root /var/lib/tomcat/webapps/"${app_name}"
    chmod 0755 /var/lib/tomcat/webapps/"${app_name}"
    install -m 644 -o root -g root "${warfile}" /var/lib/tomcat/webapps/
}

deployWarFiles() {
    find "${uploads_dir}" -maxdepth 1 -type f \( -name '*.war' -o -name '*.WAR' \) -print0 | while read -r -d $'\0' f
    do
        deployWarFile "${f}"
    done
}

main() {
    installDependencies
    installTomcat
    deployWarFiles

    if command -v sestatus ; then disableSELinux ; fi

    # Only for VMs (AWS)
    # systemctl enable tomcat
}

main "$@"
