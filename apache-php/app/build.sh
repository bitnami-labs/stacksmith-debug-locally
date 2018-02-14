#!/bin/bash

yum install -y httpd
systemctl enable httpd.service
yum install -y php
yum install -y php-mysql 

echo "==== FINISH BUILD SCRIPT ===="

