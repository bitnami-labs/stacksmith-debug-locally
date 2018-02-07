#!/bin/bash

# Extra packages
yum install -y mysql && yum clean all && rm -fR /var/cache/yum

echo "=== FINISH BUILD SCRIPT ==="

