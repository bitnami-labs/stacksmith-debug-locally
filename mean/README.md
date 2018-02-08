## Build and Debug a MEAN / MERN Application Locally Before Using It with Stacksmith

This guide walks you through the process of using Docker to build and test your MEAN / MERN application locally before uploading it to Stacksmith.

### TL;DR

Clone this repository, copy your compressed application file into the `app/` directory and run the following command:

```
docker-compose up --build
```

You should now able to see the application running at `http://localhost:3000`.
If you see the application running, you can go ahead and upload it to Stacksmith.

### Step 1: Create the Dockerfile

At the time of writing, Stacksmith supports CentOS 7 as the underlying operating system.

This example copies the `scripts/` directory into the container in order to execute the scripts and it also copies the `app/app.tar.gz` file containing the MEAN / MERN application code. If you do not have a MEAN / MERN application, you can use the example from the [Stacksmith Examples](https://github.com/bitnami/stacksmith-examples/tree/master/mean/todo) repo.

```Dockerfile
FROM centos:7
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH=/opt/node-v8.9.4-linux-x64/bin:$PATH \
    UPLOADS_DIR=/app

# Install required system packages
RUN yum install -y wget

# Install node
RUN wget https://nodejs.org/dist/v8.9.4/node-v8.9.4-linux-x64.tar.xz && \
    tar xf node-v8.9.4-linux-x64.tar.xz -C /opt/ && \
    rm node-v8.9.4-linux-x64.tar.xz

# Copy Stacksmith scripts
COPY scripts /

# Add the compressed version of the application
COPY app.tar.gz /app/

# Stacksmith build.sh script
RUN /build.sh

# Stacksmith boot.sh script
ENTRYPOINT ["/boot.sh"]

# Stacksmith run.sh script
CMD ["/run.sh"]
```

### Step 2: Define the `build.sh` script

This script is executed at build time. You can add any software you need from external repositories, create any required system user, configure permissions, etc

```bash
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

```

### Step 3: Define the `boot.sh` script

This script is executed at boot time. In this case, all it does is configure the database connection and install the application dependencies with `npm`.

```bash
#!/bin/bash

# Catch errors and undefined variables
set -euo pipefail

# This is the path of the database config file inside your app
readonly database_conf_file=/opt/app/config/database.js
# The directory where the app is installed
readonly installdir=/opt/app
# The user that should run the app
readonly system_user=bitnami

# Replace config file variables with the values from the environment
sed -i -e "s/process.env.DATABASE_HOST/\"${DATABASE_HOST}\"/" "${database_conf_file}"
sed -i -e "s/process.env.DATABASE_PORT/\"${DATABASE_PORT}\"/" "${database_conf_file}"
sed -i -e "s/process.env.DATABASE_USER/\"${DATABASE_USER}\"/" "${database_conf_file}"
sed -i -e "s/process.env.DATABASE_NAME/\"${DATABASE_NAME}\"/" "${database_conf_file}"
sed -i -e "s/process.env.DATABASE_PASSWORD/\"${DATABASE_PASSWORD}\"/" "${database_conf_file}"

# Installing application dependencies
su "${system_user}" -c "cd ${installdir} && npm install"

# In order to execute the run.sh script as CMD for Docker
exec "$@"
```

### Step 4: Define the `run.sh` script

This script is executed to start your application. The example showed below just starts the application as an unprivileged user.

```bash
#!/bin/bash

# Catch errors and undefined variables
set -euo pipefail

# The directory where the app is installed
readonly installdir=/opt/app
# The user that should run the app
readonly system_user=bitnami

# Typically this is used to start something on foreground
exec su "${system_user}" -c "cd ${installdir} && npm start"
```

### Step 5: Build the Docker image and test the application

After adding your application tarball to the `app/` directory and customising the scripts, build the Docker image and run it locally. The following command should be executed in the same directory as the `Dockerfile`.

```
docker-compose up --build
```

Access your web application at `http://localhost:3000`.

If your application works as expected, you can now upload the application tarball, `build.sh`, `boot.sh` and `run.sh `scripts to Stacksmith and build the AWS AMI or the Helm chart to deploy your application on AWS or in a Kubernetes cluster.
Remember to use the most appropriate template for your application. In this case select the `MEAN / MERN Stack` template.

Once the builds are complete, you can find more information about how to deploy your solution at the [Stacksmith Support page](https://beta.stacksmith.bitnami.com/support/).

### Troubleshooting

#### The container returns an error and stops

Run the container in interactive mode to debug the issue:

```
docker run -it stacksmith-mean bash
```

At the container console, execute the `/boot.sh` and the `/run.sh` scripts manually in order to investigate the problem.
