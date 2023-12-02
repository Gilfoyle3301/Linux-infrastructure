
# Lesson5: ZFS
## VagranFile развернет ВМ с развернутой zfs, выставит квоту 1Гб на каждую ФС и свой алгоритм компрессии.
## Определить алгоритм с наилучшим сжатием.

```
vagrant@systemZ-zfs:~$ zfs get compression systemZ_zfs/fs0{1,2,3,4}
NAME           PROPERTY     VALUE     SOURCE
systemZ_zfs/fs01  compression  lzjb      local
systemZ_zfs/fs02  compression  gzip-9    local
systemZ_zfs/fs03  compression  zle       local
systemZ_zfs/fs04  compression  lz4       local

vagrant@systemZ-zfs:~$ zfs get quota systemZ_zfs/fs0{1,2,3,4}
NAME           PROPERTY  VALUE  SOURCE
systemZ_zfs/fs01  quota     1G     local
systemZ_zfs/fs02  quota     1G     local
systemZ_zfs/fs03  quota     1G     local
systemZ_zfs/fs04  quota     1G     local
```
```
vagrant@systemZ-zfs:~$ stat War_and_Peace.txt 
  File: War_and_Peace.txt
  Size: 3359372         Blocks: 6568       IO Block: 4096   regular file
Device: fd00h/64768d    Inode: 524323      Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1000/ vagrant)   Gid: ( 1000/ vagrant)
Access: 2023-05-27 13:59:01.000000000 +0000
Modify: 2023-05-02 08:16:43.000000000 +0000
Change: 2023-05-27 13:59:01.951880876 +0000
 Birth: -
```
#### Размер файла 3.3 мб до коприрования в zfs
```

vagrant@systemZ-zfs:~$ df -h
Filesystem                         Size  Used Avail Use% Mounted on
udev                               444M     0  444M   0% /dev
tmpfs                               98M  988K   97M   1% /run
/dev/mapper/ubuntu--vg-ubuntu--lv  9.8G  4.5G  4.8G  49% /
tmpfs                              489M     0  489M   0% /dev/shm
tmpfs                              5.0M     0  5.0M   0% /run/lock
tmpfs                              489M     0  489M   0% /sys/fs/cgroup
/dev/loop0                          50M   50M     0 100% /snap/snapd/18357
/dev/loop1                          92M   92M     0 100% /snap/lxd/24061
/dev/loop2                          64M   64M     0 100% /snap/core20/1828
/dev/sda2                          1.7G  108M  1.5G   7% /boot
vagrant                             69G   50G   20G  72% /vagrant
systemZ_zfs                           832M  128K  832M   1% /systemZ_zfs
systemZ_zfs/fs01                      832M  128K  832M   1% /systemZ_zfs/fs01
systemZ_zfs/fs02                      832M  128K  832M   1% /systemZ_zfs/fs02
systemZ_zfs/fs03                      832M  128K  832M   1% /systemZ_zfs/fs03
systemZ_zfs/fs04                      832M  128K  832M   1% /systemZ_zfs/fs04
tmpfs                               98M     0   98M   0% /run/user/1000
/dev/loop3                          54M   54M     0 100% /snap/snapd/19122
/dev/loop4                          64M   64M     0 100% /snap/core20/1891


vagrant@systemZ-zfs:~$ sudo cp ./War_and_Peace.txt /systemZ_zfs/fs01/
vagrant@systemZ-zfs:~$ sudo cp ./War_and_Peace.txt /systemZ_zfs/fs02/
vagrant@systemZ-zfs:~$ sudo cp ./War_and_Peace.txt /systemZ_zfs/fs03/
vagrant@systemZ-zfs:~$ sudo cp ./War_and_Peace.txt /systemZ_zfs/fs04/
vagrant@systemZ-zfs:~$ df -h
Filesystem                         Size  Used Avail Use% Mounted on
udev                               444M     0  444M   0% /dev
tmpfs                               98M  988K   97M   1% /run
/dev/mapper/ubuntu--vg-ubuntu--lv  9.8G  4.5G  4.8G  49% /
tmpfs                              489M     0  489M   0% /dev/shm
tmpfs                              5.0M     0  5.0M   0% /run/lock
tmpfs                              489M     0  489M   0% /sys/fs/cgroup
/dev/loop0                          50M   50M     0 100% /snap/snapd/18357
/dev/loop1                          92M   92M     0 100% /snap/lxd/24061
/dev/loop2                          64M   64M     0 100% /snap/core20/1828
/dev/sda2                          1.7G  108M  1.5G   7% /boot
vagrant                             69G   50G   20G  72% /vagrant
systemZ_zfs                           825M  128K  825M   1% /systemZ_zfs
systemZ_zfs/fs01                      828M  2.5M  825M   1% /systemZ_zfs/fs01
systemZ_zfs/fs02                      827M  1.3M  825M   1% /systemZ_zfs/fs02
systemZ_zfs/fs03                      829M  3.3M  825M   1% /systemZ_zfs/fs03
systemZ_zfs/fs04                      825M  2.2M  825M   1% /systemZ_zfs/fs04
tmpfs                               98M     0   98M   0% /run/user/1000
/dev/loop3                          54M   54M     0 100% /snap/snapd/19122
/dev/loop4                          64M   64M     0 100% /snap/core20/1891
```
#### из результата видно, что gzip-9 имеет лучшие показатели.

## Определить настройки pool’a.

```
user@user-Standard-PC-Q35-ICH9-2009:/home/git/systemZ/zpoolexport$ sudo zpool import -d ../zpoolexport/
   pool: systemZ
     id: 6554193320433390805
  state: ONLINE
status: Some supported features are not enabled on the pool.
        (Note that they may be intentionally disabled if the
        'compatibility' property is set.)
 action: The pool can be imported using its name or numeric identifier, though
        some features will not be available without an explicit 'zpool upgrade'.
 config:

        systemZ                                  ONLINE
          mirror-0                            ONLINE
            /home/git/systemZ/zpoolexport/filea  ONLINE
            /home/git/systemZ/zpoolexport/fileb  ONLINE


user@user-Standard-PC-Q35-ICH9-2009:/home/git/systemZ/zpoolexport$ zpool status
  pool: systemZ
 state: ONLINE
status: Some supported and requested features are not enabled on the pool.
        The pool can still be used, but some features are unavailable.
action: Enable all features using 'zpool upgrade'. Once this is done,
        the pool may no longer be accessible by software that does not support
        the features. See zpool-features(7) for details.
config:

        NAME                                  STATE     READ WRITE CKSUM
        systemZ                                  ONLINE       0     0     0
          mirror-0                            ONLINE       0     0     0
            /home/git/systemZ/zpoolexport/filea  ONLINE       0     0     0
            /home/git/systemZ/zpoolexport/fileb  ONLINE       0     0     0

errors: No known data errors



NAME  PROPERTY              VALUE                  SOURCE
systemZ  type                  filesystem             -
systemZ  available             350M                   -
systemZ  readonly              off                    default
systemZ  recordsize            128K                   local
systemZ  compression           zle                    local
systemZ  checksum              sha256                 local
```

## Найти сообщение от преподавателей.
```
user@user-Standard-PC-Q35-ICH9-2009:/home/git/systemZ/zpoolexport$ sudo zfs receive systemZ/today02@27 < systemZ_task2.file
find /systemZ/today02/ -name "secret*" 2>/dev/null 
/systemZ/today02/task1/file_mess/secret_message
user@user-Standard-PC-Q35-ICH9-2009:/home/git/systemZ/zpoolexport$ cat /systemZ/today02/task1/file_mess/secret_message
https://github.com/sindresorhus/awesome
