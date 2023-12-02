### vagrant up поднимет лабу client-server logs, где настроен демон журналирования rsyslog и auditd
### P.S При конфигурирование на ubuntu выявил интересную особенность, для получения логов аудита с клиента в конфигурации отправки логов нужно активароть syslog в /etc/audisp/plugins.d/syslog.conf. Базовые настройки применимые для centOS не работают на ubuntu, логи не отправляются, ошибок не обнаружил.
 
```
Логи с клиента:
root@rsyslogServer:/home/vagrant# ls /var/spool/rsyslog/
127.0.0.1  192.168.56.10

root@rsyslogServer:/home/vagrant# ls /var/spool/rsyslog/192.168.56.10/
audispd.log        CRON.log          nginx.log     sudo.log            vboxadd.log
audisp-remote.log  dbus-daemon.log   rsyslogd.log  systemd.log         vboxadd-service.log
auditd.log         kernel.log        snapd.log     systemd-logind.log  vboxadd-service.sh.log
augenrules.log     nginx_access.log  sshd.log      useradd.log

Меняем атрибут на клиенте 
vagrant@rsyslogClient:~$ sudo chmod +x /etc/nginx/nginx.conf 

Результат на сервере -->
root@rsyslogServer:/home/vagrant# grep -i "nginx_conf" /var/spool/rsyslog/192.168.56.10/audispd.log 
Aug  6 09:13:19 rsyslogClient audispd: node=rsyslogClient type=CONFIG_CHANGE msg=audit(1691313199.736:83): auid=4294967295 ses=4294967295 op=add_rule key="nginx_conf" list=4 res=1
Aug  6 09:13:19 rsyslogClient audispd: node=rsyslogClient type=CONFIG_CHANGE msg=audit(1691313199.736:84): auid=4294967295 ses=4294967295 op=add_rule key="nginx_conf" list=4 res=1
Aug  6 09:17:50 rsyslogClient audispd: node=rsyslogClient type=SYSCALL msg=audit(1691313470.681:127): arch=c000003e syscall=268 success=yes exit=0 a0=ffffff9c a1=5607a9f69500 a2=1ed a3=ffffffff items=1 ppid=37946 pid=37948 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=4 comm="chmod" exe="/usr/bin/chmod" key="nginx_conf"
root@rsyslogServer:/home/vagrant# 
```