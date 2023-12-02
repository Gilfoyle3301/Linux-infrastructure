#!/bin/bash
echo "THIS IS CLIENT SCRIPT"
sudo apt update
sudo apt install borgbackup -y
export BORG_PASSPHRASE=123456
sudo mkdir -p /home/borg/.ssh
# sudo mkdir /root/.ssh
sudo cp /home/vagrant/client_pair/* /home/vagrant/.ssh/
sudo cp /home/vagrant/client_pair/* /root/.ssh/
sudo chown -R vagrant:vagrant /home/vagrant/.ssh/
borg init --encryption=repokey borg@192.168.56.160:/var/backup
borg create --stats --list borg@192.168.56.160:/var/backup/::"etc-{now:%Y-%m-%d_%H:%M:%S}" /etc
sudo cp /home/vagrant/units/* /etc/systemd/system/
systemctl enable borg.timer
systemctl start borg.timer


