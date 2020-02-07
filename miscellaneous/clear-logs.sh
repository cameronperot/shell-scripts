#!/usr/bin/env bash
set -euf -o pipefail

# This script is for clearing log files in /var/log/
if [ "$USER" != 'root' ]; then
	echo "You must run this script as root!"
	exit 1;
fi

#!/usr/bin/env bash
cat /dev/null > /var/log/auth.log
cat /dev/null > /var/log/daemon.log
cat /dev/null > /var/log/lastlog
cat /dev/null > /var/log/syslog
cat /dev/null > /var/log/messages
cat /dev/null > /var/log/kern.log
cat /dev/null > /var/log/wtmp
echo 'Logs have been cleared with /dev/null >'
