#!/bin/bash
# test script to mirror ansible nginx play

set -e
# installing nginx
yum -y install nginx

# making nginx.conf backup...
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

# making www and index.html...
mkdir -p /usr/share/nginx/www
echo "website test 123" > /usr/share/nginx/www/index.html

# could also create www group/user here
#
#

# placing testsite.conf...
#mv testsite.conf /etc/nginx/conf.d/ # SELinux had issues

# simple echo to avoid SELinux problems,
# will find better solution later
echo "server {" >> /etc/nginx/conf.d/testsite.conf
echo "	listen 80;" >> /etc/nginx/conf.d/testsite.conf
echo "	listen [::]:80;" >> /etc/nginx/conf.d/testsite.conf
echo "	root /usr/share/nginx/www;" >> /etc/nginx/conf.d/testsite.conf
echo "	index index.html;" >> /etc/nginx/conf.d/testsite.conf
echo "	server_name _;" >> /etc/nginx/conf.d/testsite.conf
echo "	error_page 404 /404.html;" >> /etc/nginx/conf.d/testsite.conf
echo "	location /404.html {" >> /etc/nginx/conf.d/testsite.conf
echo "	}" >> /etc/nginx/conf.d/testsite.conf
echo "}" >> /etc/nginx/conf.d/testsite.conf

# configuring firewall...
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --reload

# starting nginx
systemctl start nginx
systemctl enable nginx
