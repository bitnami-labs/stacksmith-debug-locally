#!/bin/bash

yum install -y httpd
systemctl start httpd.service
systemctl enable httpd.service
yum install -y php
systemctl restart httpd.service
yum install -y php-mysql 

echo "==== FINISH BUILD SCRIPT ===="

