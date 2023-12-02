# Lesson 3-4

## Исходная точка:

### Vagrantfile, который создаст ВМ с 2 доп.дисками

#### Выполняемые команды и вывод:
#### Уменьшаем корневой раздел

#### Создаем LV 

```
vagrant@system:~$ sudo -s
root@system:/home/vagrant# pvscan 
  PV /dev/sda3   VG ubuntu-vg       lvm2 [<17.78 GiB / <7.78 GiB free]
  Total: 1 [<17.78 GiB] / in use: 1 [<17.78 GiB] / in no VG: 0 [0   ]
root@system:/home/vagrant# pvcreate /dev/sd{b,c}
  Physical volume "/dev/sdb" successfully created.
  Physical volume "/dev/sdc" successfully created.
root@system:/home/vagrant# vgcreate vg_root /dev/sd{b,c}
  Volume group "vg_root" successfully created
root@system:/home/vagrant# lvcreate -n lvroot -l 100%FREE vg_root
  Logical volume "lvroot" created.
root@system:/home/vagrant# blkid 
/dev/sda2: UUID="1923d2c9-801b-497c-afb2-917305464a79" TYPE="ext4" PARTUUID="d7534763-60d0-41f4-b860-131a1ad9bad6"
/dev/sda3: UUID="kN99w0-ue9s-IE9D-tR0V-Rlq5-n7B4-UYxneR" TYPE="LVM2_member" PARTUUID="a669b806-85df-4ec7-851b-8cccbb4ecfe8"
/dev/mapper/ubuntu--vg-ubuntu--lv: UUID="442cdf96-b951-403a-abd4-5c61efb900e9" TYPE="ext4"
/dev/loop0: TYPE="squashfs"
/dev/loop1: TYPE="squashfs"
/dev/loop2: TYPE="squashfs"
/dev/sda1: PARTUUID="af0a3b42-c18c-45b2-b12d-ecb7f638f4b2"
/dev/sdb: UUID="PDF5DD-Hm5I-qlw4-26L7-Pbdc-5Glz-eazFzX" TYPE="LVM2_member"
/dev/sdc: UUID="9HacTj-UJyk-mec6-prGS-na4T-q1AL-EkFSt3" TYPE="LVM2_member"
```
#### Копируем корень в примотированный lvroot и меняем корень загрузки

```
root@system:/home/vagrant# mkfs.ext4 /dev/vg_root/lvroot 
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 2095104 4k blocks and 524288 inodes
Filesystem UUID: 13c95e5c-a387-4033-ae54-63b714478e6c
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done 

root@system:/home/vagrant# mount /dev/vg_root/lvroot /mnt
root@system:/home/vagrant# cp -ax / /mnt
root@system:/home/vagrant# ls /mnt/
bin   dev  home  lib32  libx32      media  opt   root  sbin  srv       sys  usr      var
boot  etc  lib   lib64  lost+found  mnt    proc  run   snap  swap.img  tmp  vagrant
root@system:/home/vagrant# for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done
root@system:/home/vagrant# chroot /mnt
root@system:/# grub-mkconfig -o /boot/grub/grub.cfg 
Sourcing file `/etc/default/grub'
Sourcing file `/etc/default/grub.d/init-select.cfg'
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-5.4.0-148-generic
Found initrd image: /boot/initrd.img-5.4.0-148-generic
done
root@system:/home/vagrant# reboot
root@system:/home/vagrant# df -h
Filesystem                  Size  Used Avail Use% Mounted on
udev                        444M     0  444M   0% /dev
tmpfs                        98M  944K   97M   1% /run
/dev/mapper/vg_root-lvroot  7.8G  7.0G  392M  95% /
tmpfs                       489M     0  489M   0% /dev/shm
tmpfs                       5.0M     0  5.0M   0% /run/lock
tmpfs                       489M     0  489M   0% /sys/fs/cgroup
/dev/loop0                   50M   50M     0 100% /snap/snapd/18357
/dev/loop3                   64M   64M     0 100% /snap/core20/1891
/dev/loop2                   92M   92M     0 100% /snap/lxd/24061
/dev/loop1                   54M   54M     0 100% /snap/snapd/19122
/dev/loop4                   64M   64M     0 100% /snap/core20/1828
/dev/sda2                   1.7G  108M  1.5G   7% /boot
tmpfs                        98M     0   98M   0% /run/user/1000
```
### Изменяем размер предыдущего тома
```
root@system:/home/vagrant# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0                       7:0    0 49.9M  1 loop /snap/snapd/18357
loop1                       7:1    0 53.2M  1 loop /snap/snapd/19122
loop2                       7:2    0 91.9M  1 loop /snap/lxd/24061
loop3                       7:3    0 63.5M  1 loop /snap/core20/1891
loop4                       7:4    0 63.3M  1 loop /snap/core20/1828
sda                         8:0    0 19.5G  0 disk 
├─sda1                      8:1    0    1M  0 part 
├─sda2                      8:2    0  1.8G  0 part /boot
└─sda3                      8:3    0 17.8G  0 part 
  └─ubuntu--vg-ubuntu--lv 253:1    0   10G  0 lvm  
sdb                         8:16   0    4G  0 disk 
└─vg_root-lvroot          253:0    0    8G  0 lvm  /
sdc                         8:32   0    4G  0 disk 
└─vg_root-lvroot          253:0    0    8G  0 lvm  /
root@system:/home/vagrant# fsck.ext4 /dev/ubuntu-vg/ubuntu-lv 
e2fsck 1.45.5 (07-Jan-2020)
/dev/ubuntu-vg/ubuntu-lv: clean, 70366/655360 files, 1230864/2621440 blocks
root@system:/home/vagrant# resize2fs -p /dev/ubuntu-vg/ubuntu-lv 8G
resize2fs 1.45.5 (07-Jan-2020)
Please run 'e2fsck -f /dev/ubuntu-vg/ubuntu-lv' first.

root@system:/home/vagrant# e2fsck -f /dev/ubuntu-vg/ubuntu-lv
e2fsck 1.45.5 (07-Jan-2020)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/ubuntu-vg/ubuntu-lv: 70366/655360 files (0.2% non-contiguous), 1230864/2621440 blocks

root@system:/home/vagrant# resize2fs -p /dev/ubuntu-vg/ubuntu-lv 8G
resize2fs 1.45.5 (07-Jan-2020)
Resizing the filesystem on /dev/ubuntu-vg/ubuntu-lv to 2097152 (4k) blocks.
Begin pass 2 (max = 23)
Relocating blocks             XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Begin pass 3 (max = 80)
Scanning inode table          XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Begin pass 4 (max = 11140)
Updating inode references     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
The filesystem on /dev/ubuntu-vg/ubuntu-lv is now 2097152 (4k) blocks long.

root@system:/home/vagrant# lvreduce --size 8G /dev/ubuntu-vg/ubuntu-lv 
  WARNING: Reducing active logical volume to 8.00 GiB.
  THIS MAY DESTROY YOUR DATA (filesystem etc.)
Do you really want to reduce ubuntu-vg/ubuntu-lv? [y/n]: y
  Size of logical volume ubuntu-vg/ubuntu-lv changed from 10.00 GiB (2560 extents) to 8.00 GiB (2048 extents).
  Logical volume ubuntu-vg/ubuntu-lv successfully resized.

root@system:/home/vagrant# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0                       7:0    0 49.9M  1 loop /snap/snapd/18357
loop1                       7:1    0 53.2M  1 loop /snap/snapd/19122
loop2                       7:2    0 91.9M  1 loop /snap/lxd/24061
loop3                       7:3    0 63.5M  1 loop /snap/core20/1891
loop4                       7:4    0 63.3M  1 loop /snap/core20/1828
sda                         8:0    0 19.5G  0 disk 
├─sda1                      8:1    0    1M  0 part 
├─sda2                      8:2    0  1.8G  0 part /boot
└─sda3                      8:3    0 17.8G  0 part 
  └─ubuntu--vg-ubuntu--lv 253:1    0    8G  0 lvm  
sdb                         8:16   0    4G  0 disk 
└─vg_root-lvroot          253:0    0    8G  0 lvm  /
sdc                         8:32   0    4G  0 disk 
└─vg_root-lvroot          253:0    0    8G  0 lvm  /
```
### Возвращаем ФС на исходное место
```
root@system:/home/vagrant# mkfs.ext4 /dev/ubuntu-vg/ubuntu-lv 
mke2fs 1.45.5 (07-Jan-2020)
/dev/ubuntu-vg/ubuntu-lv contains a ext4 file system
        last mounted on / on Sun May 21 15:32:01 2023
Proceed anyway? (y,N) y
Creating filesystem with 2097152 4k blocks and 524288 inodes
Filesystem UUID: ccbe4f06-946d-4ccf-9515-37bf3fb90a0a
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done 

root@system:/home/vagrant# mount /dev/ubuntu-vg/ubuntu-lv /mnt/
root@system:/home/vagrant# cp -ax / /mnt
root@system:/home/vagrant# for i in /dev/ /proc/ /sys/ /boot/ /run/; do mount --bind $i /mnt$i; done
root@system:/home/vagrant# chroot /mnt/                
root@system:/# grub-mkconfig -o /boot/grub/grub.cfg
Sourcing file `/etc/default/grub'
Sourcing file `/etc/default/grub.d/init-select.cfg'
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-5.4.0-148-generic
Found initrd image: /boot/initrd.img-5.4.0-148-generic
done
root@system:/# reboot
vagrant@system:~$ df -h
Filesystem                         Size  Used Avail Use% Mounted on
udev                               444M     0  444M   0% /dev
tmpfs                               98M  952K   97M   1% /run
/dev/mapper/ubuntu--vg-ubuntu--lv  7.8G  4.5G  3.0G  61% /
tmpfs                              489M     0  489M   0% /dev/shm
tmpfs                              5.0M     0  5.0M   0% /run/lock
tmpfs                              489M     0  489M   0% /sys/fs/cgroup
/dev/loop0                          50M   50M     0 100% /snap/snapd/18357
/dev/loop3                          54M   54M     0 100% /snap/snapd/19122
/dev/loop1                          64M   64M     0 100% /snap/core20/1891
/dev/loop2                          92M   92M     0 100% /snap/lxd/24061
/dev/loop4                          64M   64M     0 100% /snap/core20/1828
/dev/sda2                          1.7G  108M  1.5G   7% /boot
tmpfs                               98M     0   98M   0% /run/user/1000
```

### Создаем зеркало

```
root@system:/home/vagrant# pvcreate /dev/sd{b,c}
  Physical volume "/dev/sdb" successfully created.
  Physical volume "/dev/sdc" successfully created.
root@system:/home/vagrant# vgcreate vg_var /dev/sd{b,c}
Volume group "vg_var" successfully created

root@system:/home/vagrant# lvcreate -n var_mirror -L 2G -m1 vg_var
  Logical volume "var_mirror" created.
root@system:/home/vagrant# mkfs.ext4 /dev/vg_var/var_mirror 
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 524288 4k blocks and 131072 inodes
Filesystem UUID: 3670074b-c34f-4597-a266-2732cca04003
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376, 294912

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done 

root@system:/home/vagrant# mount /dev/vg_var/var_mirror /mnt
root@system:/home/vagrant# cp -aRx /var /mnt

root@system:/home/vagrant# umount /mnt/
root@system:/home/vagrant# mount /dev/vg_var/var_mirror /var
root@system:/home/vagrant# echo "`blkid | grep var: | awk '{print $2}'` /var ext4 defaults 0 0" >> /etc/fstab
root@system:/home/vagrant# lsblk
NAME                         MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0                          7:0    0 91.9M  1 loop /snap/lxd/24061
loop1                          7:1    0 63.3M  1 loop /snap/core20/1828
loop2                          7:2    0 49.9M  1 loop /snap/snapd/18357
loop3                          7:3    0 53.2M  1 loop /snap/snapd/19122
loop4                          7:4    0 63.5M  1 loop /snap/core20/1891
sda                            8:0    0 19.5G  0 disk 
├─sda1                         8:1    0    1M  0 part 
├─sda2                         8:2    0  1.8G  0 part /boot
└─sda3                         8:3    0 17.8G  0 part 
  └─ubuntu--vg-ubuntu--lv    253:0    0    8G  0 lvm  /
sdb                            8:16   0    4G  0 disk 
├─vg_var-var_mirror_rmeta_0  253:1    0    4M  0 lvm  
│ └─vg_var-var_mirror        253:5    0    2G  0 lvm  /var
└─vg_var-var_mirror_rimage_0 253:2    0    2G  0 lvm  
  └─vg_var-var_mirror        253:5    0    2G  0 lvm  /var
sdc                            8:32   0    4G  0 disk 
├─vg_var-var_mirror_rmeta_1  253:3    0    4M  0 lvm  
│ └─vg_var-var_mirror        253:5    0    2G  0 lvm  /var
└─vg_var-var_mirror_rimage_1 253:4    0    2G  0 lvm  
  └─vg_var-var_mirror        253:5    0    2G  0 lvm  /var
```

### Делаем Snapshot
```
root@system:/home/vagrant# vgcreate vg_home /dev/sdd
  Volume group "vg_home" successfully created
root@system:/home/vagrant# lvcreate -n lv_home -l 100%FREE vg_home
  Logical volume "lv_home" created.
root@system:/home/vagrant# mkfs.ext4 /dev/vg_home/lv_home 
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 1047552 4k blocks and 262144 inodes
Filesystem UUID: d84114a3-2356-405a-a148-a503eab99f01
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376, 294912, 819200, 884736

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done 

root@system:/home/vagrant# mount /dev/vg_home/lv_home /mnt
root@system:/home/vagrant# rsync /home/ /mnt
skipping directory .
root@system:/home/vagrant# umount /mnt
root@system:/home/vagrant# mount /dev/vg_home/lv_home /home
root@system:/home/vagrant# touch /home/file{1..20}
root@system:/home/vagrant# ls /home/
file1   file11  file13  file15  file17  file19  file20  file4  file6  file8  lost+found
file10  file12  file14  file16  file18  file2   file3   file5  file7  file9
root@system:/home/vagrant# lsblk 
NAME                         MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0                          7:0    0 91.9M  1 loop /snap/lxd/24061
loop1                          7:1    0 63.3M  1 loop /snap/core20/1828
loop2                          7:2    0 49.9M  1 loop /snap/snapd/18357
loop3                          7:3    0 53.2M  1 loop /snap/snapd/19122
loop4                          7:4    0 63.5M  1 loop /snap/core20/1891
sda                            8:0    0 19.5G  0 disk 
├─sda1                         8:1    0    1M  0 part 
├─sda2                         8:2    0  1.8G  0 part /boot
└─sda3                         8:3    0 17.8G  0 part 
  └─ubuntu--vg-ubuntu--lv    253:0    0    8G  0 lvm  /
sdb                            8:16   0    4G  0 disk 
├─vg_var-var_mirror_rmeta_0  253:1    0    4M  0 lvm  
│ └─vg_var-var_mirror        253:5    0    2G  0 lvm  /var
└─vg_var-var_mirror_rimage_0 253:2    0    2G  0 lvm  
  └─vg_var-var_mirror        253:5    0    2G  0 lvm  /var
sdc                            8:32   0    4G  0 disk 
├─vg_var-var_mirror_rmeta_1  253:3    0    4M  0 lvm  
│ └─vg_var-var_mirror        253:5    0    2G  0 lvm  /var
└─vg_var-var_mirror_rimage_1 253:4    0    2G  0 lvm  
  └─vg_var-var_mirror        253:5    0    2G  0 lvm  /var
sdd                            8:32   0    4G  0 disk 
└─vg_home-lv_home            253:1    0    2G  0 lvm  /home
root@system:/home/vagrant# lvcreate -L 100MB -s -n home_snap /dev/vg_home/lv_home
  Logical volume "home_snap" created.
root@system:/home/vagrant# lsblk
NAME                         MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0                          7:0    0 91.9M  1 loop /snap/lxd/24061
loop1                          7:1    0 63.3M  1 loop /snap/core20/1828
loop2                          7:2    0 49.9M  1 loop /snap/snapd/18357
loop3                          7:3    0 53.2M  1 loop /snap/snapd/19122
loop4                          7:4    0 63.5M  1 loop /snap/core20/1891
sda                            8:0    0 19.5G  0 disk 
├─sda1                         8:1    0    1M  0 part 
├─sda2                         8:2    0  1.8G  0 part /boot
└─sda3                         8:3    0 17.8G  0 part 
  └─ubuntu--vg-ubuntu--lv    253:0    0    8G  0 lvm  /
sdb                            8:16   0    4G  0 disk 
├─vg_var-var_mirror_rmeta_0  253:1    0    4M  0 lvm  
│ └─vg_var-var_mirror        253:5    0    2G  0 lvm  /var
└─vg_var-var_mirror_rimage_0 253:2    0    2G  0 lvm  
  └─vg_var-var_mirror        253:5    0    2G  0 lvm  /var
sdc                            8:32   0    4G  0 disk 
├─vg_var-var_mirror_rmeta_1  253:3    0    4M  0 lvm  
│ └─vg_var-var_mirror        253:5    0    2G  0 lvm  /var
└─vg_var-var_mirror_rimage_1 253:4    0    2G  0 lvm  
  └─vg_var-var_mirror        253:5    0    2G  0 lvm  /var
sdd                            8:32   0    4G  0 disk 
├─vg_home-lv_home-real       253:2    0    2G  0 lvm  
│ ├─vg_home-lv_home          253:1    0    2G  0 lvm  /home
│ └─vg_home-home_snap        253:4    0    2G  0 lvm  
└─vg_home-home_snap-cow      253:3    0  100M  0 lvm  
  └─vg_home-home_snap        253:4    0    2G  0 lvm 
```
### Восстанавливаемся
```
root@system:/home/vagrant#  rm -f /home/file{11..20}
root@system:/home/vagrant# ls /home/
file1  file10  file2  file3  file4  file5  file6  file7  file8  file9  lost+found
root@system:/home/vagrant#  umount /home
root@system:/home/vagrant# lvconvert --merge /dev/vg_home/home_snap 
  Merging of volume vg_home/home_snap started.
  vg_home/lv_home: Merged: 100.00%
root@system:/home/vagrant# mount /dev/vg_home/lv_home /home/
root@system:/home/vagrant# ls /home/
file1   file11  file13  file15  file17  file19  file20  file4  file6  file8  lost+found
file10  file12  file14  file16  file18  file2   file3   file5  file7  file9
root@system:/home/vagrant# 
```

