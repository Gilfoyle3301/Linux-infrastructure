### vagrant up развернет полностю настроенную ВМ 


```
root@user-Standard-PC-Q35-ICH9-2009:/home/git/system# ssh system@192.168.56.10
system@192.168.56.10's password: 
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-148-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

$ whoami
system

vagrant@PAMLab:~$ cat /etc/group | grep admin
admin:x:1003:systemadm,root,vagrant

vagrant@PAMLab:~$ sudo vi /usr/local/bin/login.sh

vagrant@PAMLab:~$ sudo chmod +x /usr/local/bin/login.sh
vagrant@PAMLab:~$ sudo vi /etc/pam.d/sshd 
vagrant@PAMLab:~$ cat /usr/local/bin/login.sh
#!/bin/bash
if [ $(date +%a) = "Sat" ] || [ $(date +%a) = "Sun" ]; then
 if getent group admin | grep -qw "$PAM_USER"; then      
        exit 0
      else
        exit 1
    fi
  else
    exit 0
fi
vagrant@PAMLab:~$ sudo systemctl restart sshd
vagrant@PAMLab:~$ sudo systemctl status sshd
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
     Active: active (running) since Sun 2023-07-30 13:15:45 UTC; 6s ago
       Docs: man:sshd(8)
             man:sshd_config(5)
    Process: 27027 ExecStartPre=/usr/sbin/sshd -t (code=exited, status=0/SUCCESS)
   Main PID: 27040 (sshd)
      Tasks: 1 (limit: 1064)
     Memory: 1.3M
     CGroup: /system.slice/ssh.service
             └─27040 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups

Jul 30 13:15:45 PAMLab systemd[1]: Starting OpenBSD Secure Shell server...
Jul 30 13:15:45 PAMLab sshd[27040]: Server listening on 0.0.0.0 port 22.
Jul 30 13:15:45 PAMLab systemd[1]: Started OpenBSD Secure Shell server.
vagrant@PAMLab:~$ exit
logout
root@user-Standard-PC-Q35-ICH9-2009:/home/git/system# ssh systemadm@192.168.56.10
systemadm@192.168.56.10's password: 
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-148-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

----------------------------------------------------------------
  Ubuntu20.04.6LTS                            built 2023-05-07
----------------------------------------------------------------

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

Last login: Sun Jul 30 14:19:12 2023 from 127.0.0.1
Could not chdir to home directory /home/systemadm: No such file or directory
$ exit
Connection to 192.168.56.10 closed.
root@user-Standard-PC-Q35-ICH9-2009:/home/git/system# ssh system@192.168.56.10
system@192.168.56.10's password: 
/usr/local/bin/login.sh failed: exit code 1
Connection closed by 192.168.56.10 port 22
```