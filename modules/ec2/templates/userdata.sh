#!/bin/bash
set -x
apt update -y
apt install nginx net-tools -y
systemctl start nginx
systemctl enable nginx
rm -f /var/www/html/index.html
echo "welcome nginx" >> /var/www/html/index.html
chown -R www-data:www-data /var/www/html
