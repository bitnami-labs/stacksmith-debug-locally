FROM centos:7
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH=/opt/node-v8.9.4-linux-x64/bin:$PATH \
    UPLOADS_DIR=/app

# Install required system packages
RUN yum install -y wget which

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
