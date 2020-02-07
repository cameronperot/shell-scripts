#!/usr/bin/env bash
set -euf -o pipefail

if [ "$USER" != 'root' ]; then
        echo "You must run this script as root!"
        exit 1;
fi

cd /etc/nginx/sites-available
cp cameronperot.com cameronperot.com.bak
cp default cameronperot.com
systemctl restart nginx
certbot renew
cp cameronperot.com.bak cameronperot.com
systemctl restart nginx
cd /home/cameron
