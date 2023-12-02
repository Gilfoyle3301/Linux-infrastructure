    sudo apt update
    sudo apt install parted -y
    # wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v6.3/amd64//llinux-headers-6.3.0-060300-generic_6.3.0-060300.202304232030_amd64.deb
    # wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v6.3/amd64//linux-headers-6.3.0-060300_6.3.0-060300.202304232030_all.deb
    # wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v6.3/amd64//linux-image-unsigned-6.3.0-060300-generic_6.3.0-060300.202304232030_amd64.deb
    # wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v6.3/amd64/linux-modules-6.3.0-060300-generic_6.3.0-060300.202304232030_amd64.deb
    # sudo dpkg -i *.deb
    echo "=====BUILD RAID0====="
    mdadm --zero-superblock /dev/sd{b,c}
    wipefs --all --force /dev/sd{b,c}
    mdadm --create --verbose /dev/md127 -l 0 -n 2 /dev/sd{b,c}
    sudo parted -s /dev/md127 mktable gpt
    sudo parted /dev/md127 mkpart primary ext4 0% 20%
    sudo parted /dev/md127 mkpart primary ext4 20% 40%
    sudo parted /dev/md127 mkpart primary ext4 40% 60%
    sudo parted /dev/md127 mkpart primary ext4 60% 80%
    sudo parted /dev/md127 mkpart primary ext4 80% 100%
    for i in $(seq 1 5); do sudo mkfs.ext4 /dev/md127p$i; done
    mkdir -p /raid/part{1,2,3,4,5}
    for i in $(seq 1 5); do mount /dev/md127p$i /raid/part$i; done
    echo "=====ADD TO FSTAB====="
    for i in $(seq 1 5); do echo "$(blkid /dev/md127p$i | awk '{print $2}') /raid/part$i   ext4    defaults    0 0  " >> /etc/fstab; done
    echo "=====ADD TO MDADM.CONF====="
    echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
    mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
    sudo reboot