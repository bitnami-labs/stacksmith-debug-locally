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
