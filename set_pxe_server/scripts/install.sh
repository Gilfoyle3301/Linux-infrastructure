#!/bin/bash
sudo mkdir /tftpboot
sudo wget -P /tftpboot -r --no-parent -nH --cut-dir=8 https://mirror.yandex.ru/debian/dists/bullseye/main/installer-amd64/current/images/netboot/

sudo apt update
sudo apt install isc-dhcp-server apache2 tftpd-hpa syslinux-common syslinux-efi -y
#Configure tftpd
sudo chmod 777 /etc/default/tftpd-hpa
cat << EOF > /etc/default/tftpd-hpa
# /etc/default/tftpd-hpa

TFTP_USERNAME="tftp"
TFTP_DIRECTORY="/tftpboot/"
TFTP_ADDRESS=":69"
TFTP_OPTIONS="-4 --secure"
RUN_DAEMON="yes"
EOF
sudo chmod 755 /etc/default/tftpd-hpa
#Configure dhcp
sudo sed -i 's/INTERFACESv4=""/INTERFACESv4="enp0s8"/g' /etc/default/isc-dhcp-server
sudo chmod 777 /etc/dhcp/dhcpd.conf
sudo cat  << EOF >> /etc/dhcp/dhcpd.conf

subnet 192.168.56.0 netmask 255.255.255.0 {
    range 192.168.56.151 192.168.56.159;
    next-server 192.168.56.160;

    option bootfile-name "pxelinux.0";

}
EOF
#Configure apache
sudo chmod 777 /etc/apache2/apache2.conf
sudo cat  << EOF >> /etc/apache2/apache2.conf
Alias /deb /tftpboot
<Directory /tftpboot>
    Options Indexes FollowSymLinks
    Require all granted
</Directory>
EOF
#other setings
sudo chmod 755 /etc/apache2/apache2.conf
sudo chmod 755 /etc/dhcp/dhcpd.conf
sudo tar -xvf /tftpboot/netboot.tar.gz .
sudo cp /tftpboot/debian-installer/amd64/boot-screens/ldlinux.c32 /tftpboot/
sudo systemctl restart apache2
sudo systemctl restart tftpd-hpa
sudo systemctl restart isc-dhcp-server