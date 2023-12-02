
## Systemd
### Написать сервис, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова. Файл и слово должны задаваться в /etc/sysconfig

#### vagrant-up поднимет виртуалку и запустит скрипт runUnit.sh который "Приготовит" окружение и запустит все юниты.

#### Результаты работы скрипта:
```
root@-bilder-app:/home/vagrant# systemctl status spawn-fcgi.service
● spawn-fcgi.service - Spawn-fcgi startup service by 
     Loaded: loaded (/etc/systemd/system/spawn-fcgi.service; disabled; vendor preset: enabled)
     Active: active (running) since Sun 2023-06-04 19:19:07 UTC; 1s ago
   Main PID: 43779 (php-cgi)
      Tasks: 33 (limit: 1064)
     Memory: 14.2M
     CGroup: /system.slice/spawn-fcgi.service
             ├─43779 /usr/bin/php-cgi
             ├─43790 /usr/bin/php-cgi
```
#### Подготовленные конфиги в /etc/apache2-* позволяют без проблем запусть по шаблоную n-инстансов сервера

```
[Unit]
Description=The Apache HTTP Server
After=network.target remote-fs.target nss-lookup.target
ConditionPathIsDirectory=/etc/apache2-%i
Documentation=https://httpd.apache.org/docs/2.4/

[Service]
Type=forking
Environment=APACHE_CONFDIR=/etc/apache2-%i APACHE_STARTED_BY_SYSTEMD=true
ExecStart=/usr/sbin/apachectl start
ExecStop=/usr/sbin/apachectl stop
ExecReload=/usr/sbin/apachectl graceful
PrivateTmp=true
Restart=on-abort

[Install]
WantedBy=multi-user.target
```
```
root@bilder-app:/etc/apache2-test# ss -tnulp | grep apache2
tcp    LISTEN  0        511                 0.0.0.0:80            0.0.0.0:*      users:(("apache2",pid=17573,fd=3),("apache2",pid=17572,fd=3),("apache2",pid=17571,fd=3),("apache2",pid=17570,fd=3),("apache2",pid=17569,fd=3),("apache2",pid=17548,fd=3))
tcp    LISTEN  0        511                 0.0.0.0:90            0.0.0.0:*      users:(("apache2",pid=36815,fd=3),("apache2",pid=36814,fd=3),("apache2",pid=36813,fd=3),("apache2",pid=36812,fd=3),("apache2",pid=36811,fd=3),("apache2",pid=36810,fd=3))
root@-bilder-app:/etc/apache2-test# systemctl status apache2@test.service
● apache2@test.service - The Apache HTTP Server
     Loaded: loaded (/lib/systemd/system/apache2@.service; enabled; vendor preset: enabled)
     Active: active (running) since Sun 2023-06-04 18:41:16 UTC; 6min ago
       Docs: https://httpd.apache.org/docs/2.4/
    Process: 36797 ExecStart=/usr/sbin/apachectl start (code=exited, status=0/SUCCESS)
   Main PID: 36810 (apache2)
      Tasks: 6 (limit: 1064)
     Memory: 9.9M
     CGroup: /system.slice/system-apache2.slice/apache2@test.service
             ├─36810 /usr/sbin/apache2 -d /etc/apache2-test -k start
             ├─36811 /usr/sbin/apache2 -d /etc/apache2-test -k start
             ├─36812 /usr/sbin/apache2 -d /etc/apache2-test -k start
             ├─36813 /usr/sbin/apache2 -d /etc/apache2-test -k start
             ├─36814 /usr/sbin/apache2 -d /etc/apache2-test -k start
             └─36815 /usr/sbin/apache2 -d /etc/apache2-test -k start

Jun 04 18:41:16 -bilder-app systemd[1]: Starting The Apache HTTP Server...
Jun 04 18:41:16 -bilder-app apachectl[36807]: AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 127.0.2.1.>
Jun 04 18:41:16 -bilder-app systemd[1]: Started The Apache HTTP Server.
root@-bilder-app:/etc/apache2-test# systemctl stop apache2@test.service
root@-bilder-app:/etc/apache2-test# ss -tnulp | grep apache2
tcp    LISTEN  0        511                 0.0.0.0:80            0.0.0.0:*      users:(("apache2",pid=17573,fd=3),("apache2",pid=17572,fd=3),("apache2",pid=17571,fd=3),("apache2",pid=17570,fd=3),("apache2",pid=17569,fd=3),("apache2",pid=17548,fd=3))
root@-bilder-app:/etc/apache2-test# 
```