#!/bin/bash

sudo apt update
sudo apt install nfs-kernel-server
sudo mkdir -p /srv/upload 
sudo chmod 777 /srv/upload 
sudo echo "/srv/upload/ 192.168.1.0/24(rw,sync,subtree_check,secure)" >> /etc/exports
sudo exportfs -r
sudo exportfs -s
sudo systemctl restart nfs-server


