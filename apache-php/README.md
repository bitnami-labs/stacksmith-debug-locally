## How to debug a PHP application locally.

This guide will provide the guidelines to use Docker containers for developing and testing your Stacksmith scripts locally.

### TL;DR;

To start, clone this repo and copy your PHP application into the "app/" folder. If you don't have an application, the app folder contains a small PHP MYSQL application that can be used as an example.

Here's an overview of the Dockerfile and the scripts that will be executed.

### The Dockerfile

At the time of writing this guide, Stacksmith supports CentOS 7 as the underlying OS.

This example copies the "app" and the "php" folders to the container in order to execute the scripts and to add the application files to the htdocs folder. 

```
FROM centos:7
LABEL maintainer "Bitnami <containers@bitnami.com>"
COPY app/php/ /var/www/html/
COPY app/ /app
EXPOSE 80 443
RUN /app/build.sh
ENTRYPOINT ["/app/boot.sh"]
CMD ["/usr/sbin/httpd", "-DFOREGROUND"]
```

### build.sh

This script is executed at build time. You can add any software you need from the repositories in addition to Apache and PHP.

```
#!/bin/bash

yum install -y httpd
systemctl enable httpd.service
yum install -y php
yum install -y php-mysql 

echo "==== FINISH BUILD SCRIPT ===="
```

### boot.sh

This script is executed at boot time. 

```
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
exec "$@"
```

### Deploy & test your application

After adding your PHP Application to the "app/" folder and customizing the scripts, you can build the docker image to run it locally. The following commands should be executed in the same folder of the "Dockerfile".

```
docker-compose build 
docker-compose up
```

You can access your web application at http://localhost:8080. 

To run the sample application included in the app folder open the following url: 

You can access your web application at http://localhost:8080/install.php 

And then:

You can access your web application at http://localhost:8080/public:

If your app works as expected, you can now upload the PHP Application, the "build.sh" and the "boot.sh" scripts to Stacksmith and build the AWS AMI or the helm chart to deploy your app in a Kubernetes cluster.

You can find more information about how to deploy your solution at the [Stacksmith Support page](https://beta.stacksmith.bitnami.com/support/).

### Troubleshoot issues locally

#### The container returns an error and it does not keep it running

Try to run the container with the interactive console and try to figure out the issue:

```
docker run -it stacksmith bash
```

Then you are able to execute the "/app/boot.sh" and the "/app/run.sh" in order to investigate the problem running the server.


