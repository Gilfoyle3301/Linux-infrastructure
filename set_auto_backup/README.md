Команда vagrant up запустит лабу и произведет первичную настройку и бэкапирование /etc
Так же в systemd будут внесены юниты для бэкапа по расписанию (в качестве теста выставлена 1 минута)

Ниже веден результат тестирования бэкапа и восстановления из него /etc, а так же работу бэкапа по рассписанию
```
vagrant@rsyslogClient:~$ borg init --encryption=repokey borg@192.168.56.160:/var/backup/
Enter new passphrase: 
Enter same passphrase again: 
Do you want your passphrase to be displayed for verification? [yN]: n

By default repositories initialized with this version will produce security
errors if written to with an older version (up to and including Borg 1.0.8).

If you want to use these older versions, you can disable the check by running:
borg upgrade --disable-tam ssh://borg@192.168.56.160/var/backup

See https://borgbackup.readthedocs.io/en/stable/changes.html#pre-1-0-9-manifest-spoofing-vulnerability for details about the security implications.

IMPORTANT: you will need both KEY AND PASSPHRASE to access this repo!
Use "borg key export" to export the key, optionally in printable format.
Write down the passphrase. Store both at safe place(s).
vagrant@rsyslogClient:~$ borg create --stats --list borg@192.168.56.160:/var/backup/::"etc-{now:%Y-%m-%d_%H:%M:%S}" /etc
Enter passphrase for key ssh://borg@192.168.56.160/var/backup: 
A /etc/apt/sources.list.curtin.old
A /etc/apt/sources.list
A /etc/apt/apt.conf.d/01-vendor-ubuntu
A /etc/apt/apt.conf.d/01autoremove
A /etc/apt/apt.conf.d/20snapd.conf
A /etc/apt/apt.conf.d/70debconf
d /etc/apt/apt.conf.d
d /etc/apt/auth.conf.d
d /etc/apt/preferences.d
...
A /etc/subuid-
A /etc/locale.gen
A /etc/ld.so.cache
A /etc/netconfig
A /etc/libnl-3/classid
A /etc/libnl-3/pktloc
d /etc/libnl-3
A /etc/thermald/thermal-cpu-cdev-order.xml
d /etc/thermald
A /etc/UPower/UPower.conf
d /etc/UPower
/etc/shadow-: open: [Errno 13] Permission denied: '/etc/shadow-'
E /etc/shadow-
A /etc/hostname
A /etc/group-
A /etc/hosts.allow
A /etc/hosts.deny
/etc/gshadow-: open: [Errno 13] Permission denied: '/etc/gshadow-'
E /etc/gshadow-
A /etc/passwd-
A /etc/subuid
A /etc/subgid
A /etc/insserv.conf.d/rpcbind
d /etc/insserv.conf.d
A /etc/request-key.conf
A /etc/request-key.d/id_resolver.conf
d /etc/request-key.d
A /etc/idmapd.conf
A /etc/vagrant_box_build_date
A /etc/motd
A /etc/mailcap
d /etc
------------------------------------------------------------------------------
Archive name: etc-2023-08-06_12:51:00
Archive fingerprint: 6ea60f2b11e04439e36b089edb48e884947a20c930af9b1540d333132fb299ca
Time (start): Sun, 2023-08-06 12:51:06
Time (end):   Sun, 2023-08-06 12:51:08
Duration: 2.19 seconds
Number of files: 623
Utilization of max. archive size: 0%
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
This archive:                2.03 MB            825.72 kB            818.83 kB
All archives:                2.03 MB            825.72 kB            818.83 kB

                       Unique chunks         Total chunks
Chunk index:                     603                  617
------------------------------------------------------------------------------
vagrant@rsyslogClient:~$ 

vagrant@rsyslogClient:~$ borg list borg@192.168.56.160:/var/backup
Enter passphrase for key ssh://borg@192.168.56.160/var/backup: 
etc-2023-08-06_12:51:00              Sun, 2023-08-06 12:51:06 [6ea60f2b11e04439e36b089edb48e884947a20c930af9b1540d333132fb299ca]

vagrant@rsyslogClient:~$ borg extract borg@192.168.56.160:/var/backup/::etc-2023-08-06_12:51:00 etc/hostname
Enter passphrase for key ssh://borg@192.168.56.160/var/backup: 
vagrant@rsyslogClient:~$ ls
etc  README.md
vagrant@rsyslogClient:/home/borg$ sudo systemctl status borg-backup.service 
\u25cf borg-backup.service - Borg Backup
     Loaded: loaded (/etc/systemd/system/borg-backup.service; disabled; vendor preset: enabled)
     Active: inactive (dead)

Aug 06 13:17:24 rsyslogClient borg[28775]: ------------------------------------------------------------------------------
Aug 06 13:17:24 rsyslogClient borg[28775]:                        Original size      Compressed size    Deduplicated size
Aug 06 13:17:24 rsyslogClient borg[28775]: This archive:                2.06 MB            843.92 kB             90.93 kB
Aug 06 13:17:24 rsyslogClient borg[28775]: All archives:                4.10 MB              1.67 MB            909.76 kB
Aug 06 13:17:24 rsyslogClient borg[28775]:                        Unique chunks         Total chunks
Aug 06 13:17:24 rsyslogClient borg[28775]: Chunk index:                     627                 1254
Aug 06 13:17:24 rsyslogClient borg[28775]: ------------------------------------------------------------------------------
Aug 06 13:17:26 rsyslogClient systemd[1]: borg-backup.service: Succeeded.
Aug 06 13:17:26 rsyslogClient systemd[1]: Finished Borg Backup.
```