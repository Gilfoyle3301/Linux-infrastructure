#!/bin/bash
echo "THIS IS SERVER SCRIPT"
sudo chmod 777 /etc/rsyslog.conf
sudo sed -i 's/^#module(load="imtcp")/module(load="imtcp")/' /etc/rsyslog.conf
sudo sed -i 's/^#input(type="imtcp" port="514")/input(type="imtcp" port="514")/' /etc/rsyslog.conf
echo "\$AllowedSender TCP, 192.168.56.0/24, [::1]/128" >> /etc/rsyslog.conf
echo "\$template RemInputLogs, \"/var/spool/rsyslog/%FROMHOST-IP%/%PROGRAMNAME%.log\"" >> /etc/rsyslog.conf
echo "*.* ?RemInputLogs" >> /etc/rsyslog.conf
sudo chmod 644 /etc/rsyslog.conf
sudo systemctl restart rsyslog
sudo apt update
sudo apt-get install auditd audispd-plugins -y
sudo sed -i 's/^##tcp_listen_port = 60/tcp_listen_port = 60/' /etc/audit/auditd.conf
sudo systemctl restart auditd

