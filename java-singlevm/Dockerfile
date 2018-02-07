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