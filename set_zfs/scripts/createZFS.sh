echo "===========>>>>>> install zutil"
sudo apt update
sudo apt-get install zfsutils-linux -y
echo "===========>>>>>> create zpool and zfs"
sudo zpool create otus_zfs mirror /dev/sd{b,c,d,e}
for i in $(seq 1 4); do sudo zfs create otus_zfs/fs0$i; done
echo "===========>>>>>> set compression"
sudo zfs set compression=lzjb otus_zfs/fs01
sudo zfs set compression=gzip-9 otus_zfs/fs02
sudo zfs set compression=zle otus_zfs/fs03
sudo zfs set compression=lz4 otus_zfs/fs04
echo "===========>>>>>> set quotas"
for i in $(seq 1 4); do sudo zfs set quota=1G otus_zfs/fs0$i; done
