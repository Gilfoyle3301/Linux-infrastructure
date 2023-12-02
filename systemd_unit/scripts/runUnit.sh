sudo mkdir /etc/sysconfig
sudo chmod 777 /etc/sysconfig

cat << EOF >> /etc/sysconfig/watchlog
# Configuration file for my watchlog service
# Place it to /etc/sysconfig

# File and word in that file that we will be monit
WORD="ALERT"
LOG=/var/log/watchlog.log
EOF

sudo touch /opt/watchlog.sh
sudo chmod 777 /opt/watchlog.sh

cat << EOF >> /opt/watchlog.sh
#!/bin/bash

WORD=$1
LOG=$2
DATE=`date`

if grep $WORD $LOG &> /dev/null
then
logger "$DATE: I found word, Master!"
else
exit 0
fi

EOF

sudo touch /etc/systemd/system/watchlog.service
sudo chmod 777 /etc/systemd/system/watchlog.service
sudo touch /etc/systemd/system/watchlog.timer
sudo chmod 777 /etc/systemd/system/watchlog.timer

cat << EOF >> /etc/systemd/system/watchlog.service
[Unit]
Description=My watchlog service

[Service]
Type=oneshot
EnvironmentFile=/etc/sysconfig/watchlog
ExecStart=/opt/watchlog.sh $WORD $LOG
EOF

cat << EOF >> /etc/systemd/system/watchlog.timer
[Unit]
Description=Run watchlog script every 30 second

[Timer]
# Run every 30 second
OnUnitActiveSec=30
Unit=watchlog.service

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl start watchlog.timer

sudo apt update
sudo apt install spawn-fcgi php php-cli php-cgi apache2 -y

sudo touch /etc/sysconfig/spawn-fcgi
sudo chmod 777 /etc/sysconfig/spawn-fcgi
sudo useradd apache -p apache
cat << EOF >> /etc/sysconfig/spawn-fcgi
# You must set some working options before the "spawn-fcgi" service will work.
# If SOCKET points to a file, then this file is cleaned up by the init script.
#
# See spawn-fcgi(1) for all possible options.
#
# Example :
SOCKET=/var/run/php-fcgi.sock
OPTIONS="-u apache -g apache -s \$SOCKET -S -M 0600 -C 32 -F 1 -- /usr/bin/php-cgi"
EOF

sudo touch /etc/systemd/system/spawn-fcgi.service
sudo chmod 777 /etc/systemd/system/spawn-fcgi.service

cat << EOF >> /etc/systemd/system/spawn-fcgi.service
[Unit]
Description=Spawn-fcgi startup service by Otus
After=network.target

[Service]
Type=simple
PIDFile=/var/run/spawn-fcgi.pid
EnvironmentFile=/etc/sysconfig/spawn-fcgi
ExecStart=/usr/bin/spawn-fcgi -n \$OPTIONS
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl start spawn-fcgi

sudo cp -r /etc/apache2/ /etc/apache2-test/

sudo mkdir /var/log/apache2-test/
sudo chmod 777 /var/log/apache2-test/
sudo chmod 777 /etc/apache2-test/ports.conf

cat << EOF > /etc/apache2-test/ports.conf
# If you just change the port or add more ports here, you will likely also
# have to change the VirtualHost statement in
# /etc/apache2/sites-enabled/000-default.conf

Listen 90

<IfModule ssl_module>
        Listen 446
</IfModule>

<IfModule mod_gnutls.c>
        Listen 446
</IfModule>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOF

sudo systemctl start apache2@test.service