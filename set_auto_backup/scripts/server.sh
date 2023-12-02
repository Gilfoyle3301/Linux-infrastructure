#!/bin/bash
sudo apt update
sudo apt install borgbackup -y
sudo useradd -m borg -d /home/borg
sudo mkfs.ext4 /dev/sdb
sudo mkdir /var/backup
sudo mount /dev/sdb /var/backup
sudo rm -rf /var/backup/*
sudo chown borg:borg /var/backup
sudo mkdir /home/borg/.ssh
sudo mv /home/vagrant/server_pair/* /home/borg/.ssh/
sudo chmod 700 /home/borg/.ssh
sudo chmod 600 /home/borg/.ssh/authorized_keys
sudo chown -R borg:borg /home/borg/.ssh/




