#!/usr/bin/env bash
set -eu -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P)"

# This script is for updating a wordpress installation
if [ "$USER" != 'root' ]; then
	echo "You must run this script as root!"
	exit 1;
fi

# Remove old wordpress file and download new
rm -r /home/cameron/wordpress
rm /home/cameron/latest.tar.gz
wget https://wordpress.org/latest.tar.gz -O /home/cameron/latest.tar.gz
tar -xvf /home/cameron/latest.tar.gz

# Remove previous backups
rm -rf /var/www/cameronperot.com/html/wp-admin.bak
rm -rf /var/www/cameronperot.com/html/wp-includes.bak

# Backup folders
mv /var/www/cameronperot.com/html/wp-admin /var/www/cameronperot.com/html/wp-admin.bak
mv /var/www/cameronperot.com/html/wp-includes /var/www/cameronperot.com/html/wp-includes.bak
cp -r /var/www/cameronperot.com/html/wp-content /var/www/cameronperot.com/html/wp-content.bak

# Copy over required files
cp -r /home/cameron/wordpress/wp-content/* /var/www/cameronperot.com/html/wp-content/
rm -r /home/cameron/wordpress/wp-content
cp -r /home/cameron/wordpress/* /var/www/cameronperot.com/html/

echo "Update complete, if errors, restore backups"
