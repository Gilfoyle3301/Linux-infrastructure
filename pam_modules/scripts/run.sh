#!/bin/bash
sudo sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo useradd otusadm && sudo useradd otus
echo -e "otus2023\notus2023" | sudo passwd otusadm && echo -e "otus2023\notus2023" | sudo passwd otus
sudo groupadd -f admin
sudo usermod otusadm -a -G admin && usermod root -a -G admin && usermod vagrant -a -G admin
sudo cp scripts /usr/local/bin/login.sh
sudo chmod +x /usr/local/bin/login.sh
sudo sed -i '1i\account       required     /usr/lib/x86_64-linux-gnu/security/pam_exec.so /usr/local/bin/login.sh\' /etc/pam.d/sshd
sudo systemctl restart sshd
