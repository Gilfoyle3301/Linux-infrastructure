#!/bin/bash
echo "THIS IS CLIENT SCRIPT"
sudo chmod a+w /etc/rsyslog.conf
echo "*.*@@192.168.56.15:514" >> /etc/rsyslog.conf
sudo chmod a-w /etc/rsyslog.conf
sudo apt update
sudo apt install nginx -y
sudo mv /home/vagrant/ng.conf /etc/nginx/sites-enabled/default
sudo systemctl restart nginx
sudo systemctl restart rsyslog
sudo apt-get install auditd audispd-plugins -y
sudo chmod 777 /etc/audit/rules.d/audit.rules
echo "-w /etc/nginx/nginx.conf -p wa -k nginx_conf" >> /etc/audit/rules.d/audit.rules
echo "-w /etc/nginx/conf.d/* -p wa -k nginx_conf" >>  /etc/audit/rules.d/audit.rules
sudo chmod 644 /etc/audit/rules.d/audit.rules
# sudo auditctl -a exit,always -F path=/etc/nginx/nginx.conf -F perm=wa -k nginx_conf
# sudo auditctl -a exit,always -F path=/etc/nginx/conf.d/* -F perm=wa -k nginx_conf
sudo sed -i 's/name_format = NONE/name_format = HOSTNAME/' /etc/audit/auditd.conf
sudo sed -i 's/remote_server =/remote_server = 192.168.56.15/' /etc/audisp/audisp-remote.conf
sudo sed -i 's/active = no/active = yes/' /etc/audisp/plugins.d/au-remote.conf
sudo sed -i 's/active = no/active = yes/' /etc/audisp/plugins.d/syslog.conf
sudo systemctl restart auditd


