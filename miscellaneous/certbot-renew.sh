#!/usr/bin/env bash
set -eu -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P)"

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
