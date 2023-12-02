#!/bin/bash

sudo mount 192.168.1.160:/srv/upload/ /mnt
echo "This is message for share!" > /mnt/hello.log
sudo chmod o+x /etc/fstab
echo "192.168.1.160:/srv/upload/ /mnt nfs rsize=131072,wsize=131072,timeo=600,intr" >> /etc/fstab
sudo chmod o-x /etc/fstab
sudo systemctl daemon-reload 

reboot
