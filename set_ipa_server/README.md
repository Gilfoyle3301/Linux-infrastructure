# LDAP

```
vagrant up - Развернет и скофигурирует сервер IPA и клиента.
```

## Настроить аутентификацию по SSH-ключам*
Для этого нужно выполнить следующее:
```
[root@ipa ~]# sudo -i -u system-user
Creating home directory for system-user.
[system-user@ipa ~]$ 
[system-user@ipa ~]$ 
[system-user@ipa ~]$ ssh-keygen -C system-user@system.lan
Generating public/private rsa key pair.
Enter file in which to save the key (/home/system-user/.ssh/id_rsa): 
Created directory '/home/system-user/.ssh'.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/system-user/.ssh/id_rsa
Your public key has been saved in /home/system-user/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:5rdt5LpKrsMj56Jntk9kZviuesPHU0AR/elP35QOFCs system-user@system.lan
The key's randomart image is:
+---[RSA 3072]----+
|      o+         |
|      . .    .   |
|     .   . .  o  |
|     ..   oE o   |
|    . =.S.  o   .|
|     * o. . o. ..|
|   . oo.o .= .oo |
|    XoOo . o+ ...|
|  oBo@==o.++.    |
+----[SHA256]-----+
[system-user@ipa ~]$ klist
klist: Credentials cache 'KCM:1718200003' not found
[system-user@ipa ~]$ kinit system-user
Password for system-user@system.LAN: 
[system-user@ipa ~]$ klist
Ticket cache: KCM:1718200003
Default principal: system-user@system.LAN

Valid starting     Expires            Service principal
07/19/23 10:58:59  07/20/23 10:57:29  krbtgt/system.LAN@system.LAN
[system-user@ipa ~]$ ipa user-mod system-user --sshpubkey="$(cat /home/system-user/.ssh/id_rsa.pub)"
-------------------------
Modified user "system-user"
-------------------------
  User login: system-user
  First name: system
  Last name: User
  Home directory: /home/system-user
  Login shell: /bin/sh
  Principal name: system-user@system.LAN
  Principal alias: system-user@system.LAN
  Email address: system-user@system.lan
  UID: 1718200003
  GID: 1718200003
  SSH public key: ssh-rsa
                  AAAAB3NzaC1yc2EAAAADAQABAAABgQDTiMqpN/n40U6mxfJbdDW+QTE7uaXNEjalCQrEYZukWP2r+hBHA+922vKdhs2/5lNxSoQaWGhKVsLVB3Zli42cXJnpwH3qHTNdT5TJOTfnsfbAoClRuo2DSPJuRnx7gdOd758/JvQBbfYCJ2EB8mWJL11JIzbmkzhbnQzD9Z8lu1cT26hglEIZ99Z64+lcDeXpSniUrTJmdIyS0yQiKIhWQemb5AcfTdZMkBceoREJXATJUcT8xgm6w5tLkf//ODapJ52CXLnT5C4VzEAT3DHCoMHyBHiXO69gZoR5t4EtG7O+Oc/amzpXXRlwsVzNTJPEP9PKlD56L9Q5cGlwHiQC0dDPg5D9lNwmDhIg0AdFYbdDocGeCqZ0gUvCPn1GI63Hg2FlbnPKUpDfF+uDH4hba9cHfJ+kdENoKtkEKkaQ+nIDDGIyrBubWR4sNcgn8b0GXr0fmvwfFf38PPz2NExa+pzTFs+BrvdrhFprr0STr3OzFXrwCATJX01beB8QiAs=
                  system-user@system.lan
  SSH public key fingerprint: SHA256:5rdt5LpKrsMj56Jntk9kZviuesPHU0AR/elP35QOFCs system-user@system.lan (ssh-rsa)
  Account disabled: False
  Password: True
  Member of groups: ipausers
  Kerberos keys available: True
[system-user@ipa ~]$ ssh -o GSSAPIAuthentication=no 192.168.50.11
The authenticity of host '192.168.50.11 (<no hostip for proxy command>)' can't be established.
ED25519 key fingerprint is SHA256:mw+CTnBTCvP94mi+D4rmtDue3TXiSViKiv1fMBU4J1w.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.50.11' (ED25519) to the list of known hosts.
[system-user@client1 ~]$ 
[system-user@client1 ~]$ 
[system-user@client1 ~]$ su -
Password: 
[root@client1 ~]# journalctl -u sshd -S "5 minutes ago" --no-pager
Jul 19 08:00:50 client1.system.lan sshd[21618]: main: sshd: ssh-rsa algorithm is disabled
Jul 19 08:00:55 client1.system.lan sshd[21618]: Accepted publickey for system-user from 192.168.50.10 port 35628 ssh2: RSA SHA256:5rdt5LpKrsMj56Jntk9kZviuesPHU0AR/elP35QOFCs
```