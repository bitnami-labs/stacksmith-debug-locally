FROM centos:7
LABEL maintainer "Bitnami <containers@bitnami.com>"
COPY app/php/ /var/www/html/
COPY app/ /app
EXPOSE 80 443
RUN /app/build.sh
ENTRYPOINT ["/app/boot.sh"]
CMD ["/usr/sbin/httpd", "-DFOREGROUND"]