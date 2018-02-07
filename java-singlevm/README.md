## How to debug locally a Tomcat application

This guide will provide the guidelines to use Docker containers for developing and testing your Stacksmith scripts locally.

### TL;DR;

Clone this repo, copy your war file into the "app/" folder and run the following commands:

```
docker build . -t stacksmith
docker run run -it --rm -p 8080:8080 stacksmith

```
You should now able to see the app running at http://localhost:8080/NAME Where NAME is the name of the war file.

### The Dockerfile

At the time of writing this guide, Stacksmith supports CentOS 7 as the underlying OS.

This example copies the "app/" folder into the container in order to execute the scripts and deploy the "war" file. If you do not have a war application, download the [Tomcat 7 sample war file](https://tomcat.apache.org/tomcat-7.0-doc/appdev/sample/sample.war).

```
FROM centos:7
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Scripts
COPY ./app /app
WORKDIR /app
ENV UPLOADS_DIR /app

# Build script
RUN chmod 755 *.sh && ./build-stacksmith.sh
RUN ./build.sh

ENTRYPOINT ["/app/boot.sh"]
CMD ["/app/run.sh"]
```

### build.sh

This script is executed at build time. You can add any software you need from the repositories in addition to Java and Tomcat.

```
#!/bin/bash

# Extra packages
yum install -y mysql && yum clean all && rm -fR /var/cache/yum

echo "=== FINISH BUILD SCRIPT ==="
```

### boot.sh

This script is executed at boot time. In this case it configures the JAVA_OPTS.

```
#!/bin/bash
set -euo pipefail

#Configure JAVA_OPTS
echo "JAVA_OPTS=\"-Djava.awt.headless=true -Xmx512m\"" >> /usr/share/tomcat/conf/tomcat.co
nf

echo "=== FINISH BOOT SCRIPT ==="
exec "$@"

```

### Deploy & test your application

After adding your war file into the "app/" folder and customize the scripts, you can build the docker image and run it locally. The following commands should be executed in the same folder of the "Dockerfile".

```
docker build . -t stacksmith
docker run run -it --rm -p 8080:8080 stacksmith
```

You can access your web application at http://localhost:8080/NAME where NAME is the name of the war file.

If your app works as expected, you can now upload the war file, the "build.sh" and the "boot.sh" scripts to Stacksmith and build the AWS AMI or the helm chart to deploy your app in a Kubernetes cluster.

Once the builds are done, you can find more information about how to deploy your solution at the [Stacksmith Support page](https://beta.stacksmith.bitnami.com/support/).

### Troubleshoot issues locally

#### The container returns an error and it does not keep it running

Try to run the container with the interactive console and try to figure out the issue:

```
docker run -it stacksmith bash
```

Then you are able to execute the "/app/boot.sh" and the "/app/run.sh" in order to investigate the problem running the server.

#### The server is running but the app is not deployed correctly

The main Tomcat log file is shown in the output directly. It could be possible you need to add extra libraries in Tomcat "shared/" folder or configure the memory properly.

The example below requires to configure the hibernate properties.

```
2018-02-06 17:09:49,371 ERROR ContextLoader,localhost-startStop-1:331 - Context initialization failed
org.springframework.beans.factory.BeanInitializationException: Could not load properties; nested exception is java.io.FileNotFoundException: Could not open ServletContext resource [/WEB-INF/hibernate.properties]
```

