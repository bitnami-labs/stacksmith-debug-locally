## Build and Debug a Java/Tomcat Application Locally Before Using It with Stacksmith

This guide walks you through the process of using Docker to build and test your Java/Tomcat application locally before uploading it to Stacksmith.

### TL;DR

Clone this repository, copy your WAR file into the `app/` directory and run the following commands:

```
docker build . -t stacksmith
docker run -it --rm -p 8080:8080 stacksmith
```

You should now able to see the application running at `http://localhost:8080/NAME`, where NAME is the name of the WAR file. If you see the application running, you can go ahead and upload it to Stacksmith.

### Step 1: Create the Dockerfile

At the time of writing, Stacksmith supports CentOS 7 as the underlying operating system.

This example copies the `app/` directory into the container in order to execute the scripts and deploy the WAR file. If you do not have a WAR application, download the [Tomcat 7 sample WAR file](https://tomcat.apache.org/tomcat-7.0-doc/appdev/sample/sample.war).

```
FROM centos:7
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Scripts
COPY ./app /app
WORKDIR /app
ENV UPLOADS_DIR /app

# Tomcat installation and war deployment
RUN chmod 755 *.sh && ./build-stacksmith.sh

# Build script
RUN ./build.sh

# Boot script
ENTRYPOINT ["/app/boot.sh"]

# Start Tomcat
CMD ["/app/run.sh"]
```

### Step 2: Define the `build.sh` script

This script is executed at build time. You can add any software you need from external repositories, in addition to Java and Tomcat.

```
#!/bin/bash

# Extra packages
yum install -y mysql && yum clean all && rm -fR /var/cache/yum

echo "=== FINISH BUILD SCRIPT ==="
```

### Step 3: Define the `boot.sh` script

This script is executed at boot time. In this case, all it does is configure the `JAVA_OPTS` variable, but you can add other steps to it as well if needed.

```
#!/bin/bash
set -euo pipefail

#Configure JAVA_OPTS
echo "JAVA_OPTS=\"-Djava.awt.headless=true -Xmx512m\"" >> /usr/share/tomcat/conf/tomcat.conf

echo "=== FINISH BOOT SCRIPT ==="
exec "$@"

```

### Step 4: Build the Docker image and test the application

After adding your WAR file to the `app/` directory and customizing the scripts, build the Docker image and run it locally. The following commands should be executed in the same directory as the `Dockerfile`.

```
docker build . -t stacksmith
docker run -it --rm -p 8080:8080 stacksmith
```

Access your web application at `http://localhost:8080/NAME`, where NAME is the name of the WAR file.

If your application works as expected, you can now upload the WAR file, `build.sh` and `boot.sh` scripts to Stacksmith and build the AWS AMI or the Helm chart to deploy your application on AWS or in a Kubernetes cluster.

Once the builds are complete, you can find more information about how to deploy your solution at the [Stacksmith Support page](https://beta.stacksmith.bitnami.com/support/).

### Troubleshooting

#### The container returns an error and stops

Run the container in interactive mode to debug the issue:

```
docker run -it stacksmith-mean bash
```

At the container console, execute the `/boot.sh` and the `/run.sh` scripts manually in order to investigate the problem.
