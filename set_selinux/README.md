## Задание №1
```
[root@selinux vagrant]# systemctl status firewalld
● firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
     Docs: man:firewalld(1)

nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful

[root@selinux vagrant]#  getenforce 
Enforcing

[root@selinux vagrant]# cat /var/log/audit/audit.log | grep denied 
type=AVC msg=audit(1688419117.933:854): avc:  denied  { name_bind } for  pid=2889 comm="nginx" src=5678 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:unreserved_port_t:s0 tclass=tcp_socket permissive=0

[root@selinux vagrant]# yum install policycoreutils-python -y  

Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 = base: ftp.jaist.ac.jp
 = epel: mirror-hnd.yuki.net.uk
 = extras: ftp.jaist.ac.jp
 = updates: ftp.jaist.ac.jp
Resolving Dependencies
--> Running transaction check
---> Package policycoreutils-python.x86_64 0:2.5-34.el7 will be installed
--> Processing Dependency: setools-libs >= 3.3.8-4 for package: policycoreutils-python-2.5-34.el7.x86_64
...

  python-IPy.noarch 0:0.75-6.el7              setools-libs.x86_64 0:3.3.8-4.el7          

Complete!

root@selinux vagrant]# grep 1688419117.933:854 /var/log/audit/audit.log | audit2why       
type=AVC msg=audit(1688419117.933:854): avc:  denied  { name_bind } for  pid=2889 comm="nginx" src=5678 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:unreserved_port_t:s0 tclass=tcp_socket permissive=0

	Was caused by:
	The boolean nis_enabled was set incorrectly. 
	Description:
	Allow nis to enabled

	Allow access by executing:
	# setsebool -P nis_enabled 1

setsebool -P nis_enabled on         #enable parametr nis_enabled

[root@selinux vagrant]# systemctl restart nginx
[root@selinux vagrant]# systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since Mon 2023-07-03 21:42:19 UTC; 8s ago
  Process: 3073 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
  Process: 3071 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
  Process: 3070 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
 Main PID: 3075 (nginx)
   CGroup: /system.slice/nginx.service
           ├─3075 nginx: master process /usr/sbin/nginx
           └─3076 nginx: worker process

Jul 03 21:42:19 selinux systemd[1]: Stopped The nginx HTTP and reverse proxy server.
Jul 03 21:42:19 selinux systemd[1]: Starting The nginx HTTP and reverse proxy server...
Jul 03 21:42:19 selinux nginx[3071]: nginx: the configuration file /etc/nginx/nginx... ok
Jul 03 21:42:19 selinux nginx[3071]: nginx: configuration file /etc/nginx/nginx.con...ful
Jul 03 21:42:19 selinux systemd[1]: Started The nginx HTTP and reverse proxy server.
Hint: Some lines were ellipsized, use -l to show in full.

                                                                        
[root@selinux vagrant]# curl http://10.0.2.15:5678 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title>Welcome to CentOS</title>
  <style rel="stylesheet" type="text/css"> 

	html {
	background-image:url(img/html-background.png);
	background-color: white;
	font-family: "DejaVu Sans", "Liberation Sans", sans-serif;
	font-size: 0.85em;
	line-height: 1.25em;
	margin: 0 4% 0 4%;
	}

	body {
	border: 10px solid #fff;
	margin:0;
	padding:0;
	background: #fff;
	}

	/= Links =/

	a:link { border-bottom: 1px dotted #ccc; text-decoration: none; color: #204d92; }
	a:hover { border-bottom:1px dotted #ccc; text-decoration: underline; color: green; }
	a:active {  border-bottom:1px dotted #ccc; text-decoration: underline; color: #204d92; }
	a:visited { border-bottom:1px dotted #ccc; text-decoration: none; color: #204d92; }
	a:visited:hover { border-bottom:1px dotted #ccc; text-decoration: underline; color: green; }
 
	.logo a:link,
	.logo a:hover,
	.logo a:visited { border-bottom: none; }

	.mainlinks a:link { border-bottom: 1px dotted #ddd; text-decoration: none; color: #eee; }
	.mainlinks a:hover { border-bottom:1px dotted #ddd; text-decoration: underline; color: white; }
	.mainlinks a:active { border-bottom:1px dotted #ddd; text-decoration: underline; color: white; }
	.mainlinks a:visited { border-bottom:1px dotted #ddd; text-decoration: none; color: white; }
	.mainlinks a:visited:hover { border-bottom:1px dotted #ddd; text-decoration: underline; color: white; }

	/= User interface styles =/

	#header {
	margin:0;
	padding: 0.5em;
	background: #204D8C url(img/header-background.png);
	text-align: left;
	}

	.logo {
	padding: 0;
	/= For text only logo =/
	font-size: 1.4em;
	line-height: 1em;
	font-weight: bold;
	}

	.logo img {
	vertical-align: middle;
	padding-right: 1em;
	}

	.logo a {
	color: #fff;
	text-decoration: none;
	}

	p {
	line-height:1.5em;
	}

	h1 { 
		margin-bottom: 0;
		line-height: 1.9em; }
	h2 { 
		margin-top: 0;
		line-height: 1.7em; }

	#content {
	clear:both;
	padding-left: 30px;
	padding-right: 30px;
	padding-bottom: 30px;
	border-bottom: 5px solid #eee;
	}

    .mainlinks {
        float: right;
        margin-top: 0.5em;
        text-align: right;
    }

    ul.mainlinks > li {
    border-right: 1px dotted #ddd;
    padding-right: 10px;
    padding-left: 10px;
    display: inline;
    list-style: none;
    }

    ul.mainlinks > li.last,
    ul.mainlinks > li.first {
    border-right: none;
    }

  </style>

</head>

<body>

<div id="header">

    <ul class="mainlinks">
        <li> <a href="http://www.centos.org/">Home</a> </li>
        <li> <a href="http://wiki.centos.org/">Wiki</a> </li>
        <li> <a href="http://wiki.centos.org/GettingHelp/ListInfo">Mailing Lists</a></li>
        <li> <a href="http://www.centos.org/download/mirrors/">Mirror List</a></li>
        <li> <a href="http://wiki.centos.org/irc">IRC</a></li>
        <li> <a href="https://www.centos.org/forums/">Forums</a></li>
        <li> <a href="http://bugs.centos.org/">Bugs</a> </li>
        <li class="last"> <a href="http://wiki.centos.org/Donate">Donate</a></li>
    </ul>

	<div class="logo">
		<a href="http://www.centos.org/"><img src="img/centos-logo.png" border="0"></a>
	</div>

</div>

<div id="content">

	<h1>Welcome to CentOS</h1>

	<h2>The Community ENTerprise Operating System</h2>

	<p><a href="http://www.centos.org/">CentOS</a> is an Enterprise-class Linux Distribution derived from sources freely provided
to the public by Red Hat, Inc. for Red Hat Enterprise Linux.  CentOS conforms fully with the upstream vendors
redistribution policy and aims to be functionally compatible. (CentOS mainly changes packages to remove upstream vendor
branding and artwork.)</p>

	<p>CentOS is developed by a small but growing team of core
developers.&nbsp; In turn the core developers are supported by an active user community
including system administrators, network administrators, enterprise users, managers, core Linux contributors and Linux enthusiasts from around the world.</p>

	<p>CentOS has numerous advantages including: an active and growing user community, quickly rebuilt, tested, and QA'ed errata packages, an extensive <a href="http://www.centos.org/download/mirrors/">mirror network</a>, developers who are contactable and responsive, Special Interest Groups (<a href="http://wiki.centos.org/SpecialInterestGroup/">SIGs</a>) to add functionality to the core CentOS distribution, and multiple community support avenues including a <a href="http://wiki.centos.org/">wiki</a>, <a
href="http://wiki.centos.org/irc">IRC Chat</a>, <a href="http://wiki.centos.org/GettingHelp/ListInfo">Email Lists</a>, <a href="https://www.centos.org/forums/">Forums</a>, <a href="http://bugs.centos.org/">Bugs Database</a>, and an <a
href="http://wiki.centos.org/FAQ/">FAQ</a>.</p>

	</div>

</div>


</body>
</html>


[root@selinux vagrant]# getsebool -a | grep nis_enabled 
nis_enabled --> on
                                                          
setsebool -P nis_enabled off

[root@selinux vagrant]# semanage port -l | grep http 

http_cache_port_t              tcp      8080, 8118, 8123, 10001-10010
http_cache_port_t              udp      3130
http_port_t                    tcp      80, 81, 443, 488, 8008, 8009, 8443, 9000
pegasus_http_port_t            tcp      5988
pegasus_https_port_t           tcp      5989

semanage port -a -t http_port_t -p tcp 5678  

[root@selinux vagrant]# semanage port -l | grep  http_port_t
http_port_t                    tcp      5678, 80, 81, 443, 488, 8008, 8009, 8443, 9000   # see port added 
pegasus_http_port_t            tcp      5988



[root@selinux vagrant]# systemctl restart nginx   
root@selinux vagrant]# systemctl status nginx 
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since Tue 2023-07-04 11:07:04 UTC; 9s ago
  Process: 21692 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
  Process: 21689 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
  Process: 21688 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
 Main PID: 21694 (nginx)
   CGroup: /system.slice/nginx.service
           ├─21694 nginx: master process /usr/sbin/nginx
           └─21696 nginx: worker process

Jul 04 11:07:04 selinux systemd[1]: Starting The nginx HTTP and reverse proxy server...
Jul 04 11:07:04 selinux nginx[21689]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Jul 04 11:07:04 selinux nginx[21689]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Jul 04 11:07:04 selinux systemd[1]: Started The nginx HTTP and reverse proxy server.
Hint: Some lines were ellipsized, use -l to show in full.


[root@selinux vagrant]# curl http://10.0.2.15:5678

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title>Welcome to CentOS</title>
  <style rel="stylesheet" type="text/css"> 

	html {
	background-image:url(img/html-background.png);
	background-color: white;
	font-family: "DejaVu Sans", "Liberation Sans", sans-serif;
	font-size: 0.85em;
	line-height: 1.25em;
	margin: 0 4% 0 4%;
	}

	body {
	border: 10px solid #fff;
	margin:0;
	padding:0;
	background: #fff;
	}

	/= Links =/

	a:link { border-bottom: 1px dotted #ccc; text-decoration: none; color: #204d92; }
	a:hover { border-bottom:1px dotted #ccc; text-decoration: underline; color: green; }
	a:active {  border-bottom:1px dotted #ccc; text-decoration: underline; color: #204d92; }
	a:visited { border-bottom:1px dotted #ccc; text-decoration: none; color: #204d92; }
	a:visited:hover { border-bottom:1px dotted #ccc; text-decoration: underline; color: green; }
 
	.logo a:link,
	.logo a:hover,
	.logo a:visited { border-bottom: none; }

	.mainlinks a:link { border-bottom: 1px dotted #ddd; text-decoration: none; color: #eee; }
	.mainlinks a:hover { border-bottom:1px dotted #ddd; text-decoration: underline; color: white; }
	.mainlinks a:active { border-bottom:1px dotted #ddd; text-decoration: underline; color: white; }
	.mainlinks a:visited { border-bottom:1px dotted #ddd; text-decoration: none; color: white; }
	.mainlinks a:visited:hover { border-bottom:1px dotted #ddd; text-decoration: underline; color: white; }

	/= User interface styles =/

	#header {
	margin:0;
	padding: 0.5em;
	background: #204D8C url(img/header-background.png);
	text-align: left;
	}

	.logo {
	padding: 0;
	/= For text only logo =/
	font-size: 1.4em;
	line-height: 1em;
	font-weight: bold;
	}

	.logo img {
	vertical-align: middle;
	padding-right: 1em;
	}

	.logo a {
	color: #fff;
	text-decoration: none;
	}

	p {
	line-height:1.5em;
	}

	h1 { 
		margin-bottom: 0;
		line-height: 1.9em; }
	h2 { 
		margin-top: 0;
		line-height: 1.7em; }

	#content {
	clear:both;
	padding-left: 30px;
	padding-right: 30px;
	padding-bottom: 30px;
	border-bottom: 5px solid #eee;
	}

    .mainlinks {
        float: right;
        margin-top: 0.5em;
        text-align: right;
    }

    ul.mainlinks > li {
    border-right: 1px dotted #ddd;
    padding-right: 10px;
    padding-left: 10px;
    display: inline;
    list-style: none;
    }

    ul.mainlinks > li.last,
    ul.mainlinks > li.first {
    border-right: none;
    }

  </style>

</head>

<body>

<div id="header">

    <ul class="mainlinks">
        <li> <a href="http://www.centos.org/">Home</a> </li>
        <li> <a href="http://wiki.centos.org/">Wiki</a> </li>
        <li> <a href="http://wiki.centos.org/GettingHelp/ListInfo">Mailing Lists</a></li>
        <li> <a href="http://www.centos.org/download/mirrors/">Mirror List</a></li>
        <li> <a href="http://wiki.centos.org/irc">IRC</a></li>
        <li> <a href="https://www.centos.org/forums/">Forums</a></li>
        <li> <a href="http://bugs.centos.org/">Bugs</a> </li>
        <li class="last"> <a href="http://wiki.centos.org/Donate">Donate</a></li>
    </ul>

	<div class="logo">
		<a href="http://www.centos.org/"><img src="img/centos-logo.png" border="0"></a>
	</div>

</div>

<div id="content">

	<h1>Welcome to CentOS</h1>

	<h2>The Community ENTerprise Operating System</h2>

	<p><a href="http://www.centos.org/">CentOS</a> is an Enterprise-class Linux Distribution derived from sources freely provided
to the public by Red Hat, Inc. for Red Hat Enterprise Linux.  CentOS conforms fully with the upstream vendors
redistribution policy and aims to be functionally compatible. (CentOS mainly changes packages to remove upstream vendor
branding and artwork.)</p>

	<p>CentOS is developed by a small but growing team of core
developers.&nbsp; In turn the core developers are supported by an active user community
including system administrators, network administrators, enterprise users, managers, core Linux contributors and Linux enthusiasts from around the world.</p>

	<p>CentOS has numerous advantages including: an active and growing user community, quickly rebuilt, tested, and QA'ed errata packages, an extensive <a href="http://www.centos.org/download/mirrors/">mirror network</a>, developers who are contactable and responsive, Special Interest Groups (<a href="http://wiki.centos.org/SpecialInterestGroup/">SIGs</a>) to add functionality to the core CentOS distribution, and multiple community support avenues including a <a href="http://wiki.centos.org/">wiki</a>, <a
href="http://wiki.centos.org/irc">IRC Chat</a>, <a href="http://wiki.centos.org/GettingHelp/ListInfo">Email Lists</a>, <a href="https://www.centos.org/forums/">Forums</a>, <a href="http://bugs.centos.org/">Bugs Database</a>, and an <a
href="http://wiki.centos.org/FAQ/">FAQ</a>.</p>

	</div>

</div>
</body>

</html>

semanage port -d -t http_port_t -p tcp 5678 
[root@selinux vagrant]#  semanage port -l | grep  http_port_t             
http_port_t                    tcp      80, 81, 443, 488, 8008, 8009, 8443, 9000 
pegasus_http_port_t            tcp      5988
systemctl restart nginx

[root@selinux vagrant]# systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: failed (Result: exit-code) since Tue 2023-07-04 11:21:11 UTC; 13s ago
  Process: 21692 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
  Process: 21720 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=1/FAILURE)
  Process: 21719 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
 Main PID: 21694 (code=exited, status=0/SUCCESS)

Jul 04 11:21:11 selinux systemd[1]: Stopped The nginx HTTP and reverse proxy server.
Jul 04 11:21:11 selinux systemd[1]: Starting The nginx HTTP and reverse proxy server...
Jul 04 11:21:11 selinux nginx[21720]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Jul 04 11:21:11 selinux nginx[21720]: nginx: [emerg] bind() to 0.0.0.0:5678 failed (13: Permissio...ied)
Jul 04 11:21:11 selinux nginx[21720]: nginx: configuration file /etc/nginx/nginx.conf test failed
Jul 04 11:21:11 selinux systemd[1]: nginx.service: control process exited, code=exited status=1
Jul 04 11:21:11 selinux systemd[1]: Failed to start The nginx HTTP and reverse proxy server.
Jul 04 11:21:11 selinux systemd[1]: Unit nginx.service entered failed state.
Jul 04 11:21:11 selinux systemd[1]: nginx.service failed.
Hint: Some lines were ellipsized, use -l to show in full.


[root@selinux vagrant]# systemctl start nginx
Job for nginx.service failed because the control process exited with error code. See "systemctl status nginx.service" and "journalctl -xe" for details

[root@selinux vagrant]# grep nginx /var/log/audit/audit.log
type=SOFTWARE_UPDATE msg=audit(1688457970.999:823): pid=2729 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='sw="nginx-filesystem-1:1.20.1-10.el7.noarch" sw_type=rpm key_enforce=0 gpg_res=1 root_dir="/" comm="yum" exe="/usr/bin/python2.7" hostname=? addr=? terminal=? res=success'
type=SOFTWARE_UPDATE msg=audit(1688457971.177:824): pid=2729 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='sw="nginx-1:1.20.1-10.el7.x86_64" sw_type=rpm key_enforce=0 gpg_res=1 root_dir="/" comm="yum" exe="/usr/bin/python2.7" hostname=? addr=? terminal=? res=success'
type=AVC msg=audit(1688457971.353:825): avc:  denied  { name_bind } for  pid=2807 comm="nginx" src=5678 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:unreserved_port_t:s0 tclass=tcp_socket permissive=0


[root@selinux vagrant]# grep nginx /var/log/audit/audit.log | audit2allow -M nginx
==================== IMPORTANT =======================
To make this policy package active, execute:

semodule -i nginx.pp

semodule -i nginx.pp                                  

[root@selinux vagrant]# systemctl start nginx
[root@selinux vagrant]# systemctl status nginx

● nginx.service - The nginx HTTP and reverse proxy server                 
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since Tue 2023-07-04 11:34:26 UTC; 1min 47s ago
  Process: 21782 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
  Process: 21779 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
  Process: 21778 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
 Main PID: 21784 (nginx)
   CGroup: /system.slice/nginx.service
           ├─21784 nginx: master process /usr/sbin/nginx
           └─21786 nginx: worker process

Jul 04 11:34:26 selinux systemd[1]: Starting The nginx HTTP and reverse proxy server...
Jul 04 11:34:26 selinux nginx[21779]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Jul 04 11:34:26 selinux nginx[21779]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Jul 04 11:34:26 selinux systemd[1]: Started The nginx HTTP and reverse proxy server.
Hint: Some lines were ellipsized, use -l to show in full.

[root@selinux vagrant]# semodule -l |grep nginx
nginx	1.0

[root@selinux vagrant]# semodule -r nginx                                          
libsemanage.semanage_direct_remove_key: Removing last nginx module (no other nginx module exists at another priority).
```
## Задание №2
```
localadm@VBD:~/ansible/system-linux-adm/selinux_dns_problems$ vagrant status
Current machine states:

ns01                      running (virtualbox)                     # ceate 2 virtual mashine ns01 and client 
client                    running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.

==============================connect to client mashins============================
localadm@VBD:~/ansible/system-linux-adm/selinux_dns_problems$ vagrant ssh client
Last login: Tue Jul  4 14:34:05 2023 from 10.0.2.2
###############################
### Welcome to the DNS lab! ###
###############################

- Use this client to test the enviroment
- with dig or nslookup. Ex:
    dig @192.168.50.10 ns01.dns.lab

- nsupdate is available in the ddns.lab zone. Ex:
    nsupdate -k /etc/named.zonetransfer.key
    server 192.168.50.10
    zone ddns.lab 
    update add www.ddns.lab. 60 A 192.168.50.15
    send

- rndc is also available to manage the servers
    rndc -c ~/rndc.conf reload

###############################
### Enjoy! ####################
###############################
========================================chanhe zone===================================
nsupdate -k /etc/named.zonetransfer.key        
> server 192.168.50.10                        
> zone ddns.lab                              
> update add www.ddns.lab. 60 A 192.168.50.15  
> send                                         
update failed: SERVFAIL                      
> quit

sudo -i                                         
cat /var/log/audit/audit.log | audit2why      


vagrant ssh ns01 
sudo -i

[root@ns01 vagrant]# cat /var/log/audit/audit.log | audit2why 
type=AVC msg=audit(1688481828.273:1941): avc:  denied  { create } for  pid=5144 comm="isc-worker0000" name="named.ddns.lab.view1.jnl" scontext=system_u:system_r:named_t:s0 tcontext=system_u:object_r:etc_t:s0 tclass=file permissive=0

	Was caused by:
		Missing type enforcement (TE) allow rule.

		You can use audit2allow to generate a loadable module to allow this access.


[root@ns01 vagrant]# ls -laZ /etc/named
drw-rwx---. root named system_u:object_r:etc_t:s0       .
drwxr-xr-x. root root  system_u:object_r:etc_t:s0       ..
drw-rwx---. root named unconfined_u:object_r:etc_t:s0   dynamic
-rw-rw----. root named system_u:object_r:etc_t:s0       named.50.168.192.rev
-rw-rw----. root named system_u:object_r:etc_t:s0       named.dns.lab
-rw-rw----. root named system_u:object_r:etc_t:s0       named.dns.lab.view1
-rw-rw----. root named system_u:object_r:etc_t:s0       named.newdns.lab

[root@ns01 vagrant]# semanage fcontext -l | grep named
/etc/rndc.=                                        regular file       system_u:object_r:named_conf_t:s0 
/var/named(/.=)?                                   all files          system_u:object_r:named_zone_t:s0 
/etc/unbound(/.=)?                                 all files          system_u:object_r:named_conf_t:s0 
/var/run/bind(/.=)?                                all files          system_u:object_r:named_var_run_t:s0 
/var/log/named.=                                   regular file       system_u:object_r:named_log_t:s0 
/var/run/named(/.=)?                               all files          system_u:object_r:named_var_run_t:s0 
/var/named/data(/.=)?                              all files          system_u:object_r:named_cache_t:s0 
/dev/xen/tapctrl.=                                 named pipe         system_u:object_r:xenctl_t:s0 
/var/run/unbound(/.=)?                             all files          system_u:object_r:named_var_run_t:s0 
/var/lib/softhsm(/.=)?                             all files          system_u:object_r:named_cache_t:s0 
/var/lib/unbound(/.=)?                             all files          system_u:object_r:named_cache_t:s0 
/var/named/slaves(/.=)?                            all files          system_u:object_r:named_cache_t:s0 
/var/named/chroot(/.=)?                            all files          system_u:object_r:named_conf_t:s0 
/etc/named\.rfc1912.zones                          regular file       system_u:object_r:named_conf_t:s0 
/var/named/dynamic(/.=)?                           all files          system_u:object_r:named_cache_t:s0 
/var/named/chroot/etc(/.=)?                        all files          system_u:object_r:etc_t:s0 
/var/named/chroot/lib(/.=)?                        all files          system_u:object_r:lib_t:s0 
/var/named/chroot/proc(/.=)?                       all files          <<None>>
/var/named/chroot/var/tmp(/.=)?                    all files          system_u:object_r:named_cache_t:s0 
/var/named/chroot/usr/lib(/.=)?                    all files          system_u:object_r:lib_t:s0 
/var/named/chroot/etc/pki(/.=)?                    all files          system_u:object_r:cert_t:s0 
/var/named/chroot/run/named.=                      all files          system_u:object_r:named_var_run_t:s0 
/var/named/chroot/var/named(/.=)?                  all files          system_u:object_r:named_zone_t:s0 
/usr/lib/systemd/system/named.=                    regular file       system_u:object_r:named_unit_file_t:s0 
/var/named/chroot/var/run/dbus(/.=)?               all files          system_u:object_r:system_dbusd_var_run_t:s0 
/usr/lib/systemd/system/unbound.=                  regular file       system_u:object_r:named_unit_file_t:s0 
/var/named/chroot/var/log/named.=                  regular file       system_u:object_r:named_log_t:s0 
/var/named/chroot/var/run/named.=                  all files          system_u:object_r:named_var_run_t:s0 
/var/named/chroot/var/named/data(/.=)?             all files          system_u:object_r:named_cache_t:s0 
/usr/lib/systemd/system/named-sdb.=                regular file       system_u:object_r:named_unit_file_t:s0 
/var/named/chroot/var/named/slaves(/.=)?           all files          system_u:object_r:named_cache_t:s0 
/var/named/chroot/etc/named\.rfc1912.zones         regular file       system_u:object_r:named_conf_t:s0 
/var/named/chroot/var/named/dynamic(/.=)?          all files          system_u:object_r:named_cache_t:s0 


[root@ns01 vagrant]# sudo chcon -R -t named_zone_t /etc/named

[root@ns01 vagrant]# ls -laZ /etc/named
drw-rwx---. root named system_u:object_r:named_zone_t:s0 .
drwxr-xr-x. root root  system_u:object_r:etc_t:s0       ..
drw-rwx---. root named unconfined_u:object_r:named_zone_t:s0 dynamic
-rw-rw----. root named system_u:object_r:named_zone_t:s0 named.50.168.192.rev
-rw-rw----. root named system_u:object_r:named_zone_t:s0 named.dns.lab
-rw-rw----. root named system_u:object_r:named_zone_t:s0 named.dns.lab.view1
-rw-rw----. root named system_u:object_r:named_zone_t:s0 named.newdns.lab


[root@client ~]# nsupdate -k /etc/named.zonetransfer.key
> server 192.168.50.10
> zone ddns.lab
> update add www.ddns.lab. 60 A 192.168.50.15
> send
>  quit 

we connection to site www.ddns.lab and look change preference for dns zone

[root@client ~]# dig www.ddns.lab

; <<>> DiG 9.11.4-P2-RedHat-9.11.4-26.P2.el7_9.13 <<>> www.ddns.lab
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 42338
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;www.ddns.lab.			IN	A

;; ANSWER SECTION:
www.ddns.lab.		60	IN	A	192.168.50.15

;; AUTHORITY SECTION:
ddns.lab.		3600	IN	NS	ns01.dns.lab.

;; ADDITIONAL SECTION:
ns01.dns.lab.		3600	IN	A	192.168.50.10

;; Query time: 7 msec
;; SERVER: 192.168.50.10#53(192.168.50.10)
;; WHEN: Wed Jul 05 13:50:27 UTC 2023

[root@client ~]# reboot now
Connection to 127.0.0.1 closed by remote host.

[vagrant@client ~]$ dig @192.168.50.10 www.ddns.lab

; <<>> DiG 9.11.4-P2-RedHat-9.11.4-26.P2.el7_9.13 <<>> @192.168.50.10 www.ddns.lab
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 61177
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;www.ddns.lab.			IN	A

;; ANSWER SECTION:
www.ddns.lab.		60	IN	A	192.168.50.15

;; AUTHORITY SECTION:
ddns.lab.		3600	IN	NS	ns01.dns.lab.

;; ADDITIONAL SECTION:
ns01.dns.lab.		3600	IN	A	192.168.50.10

;; Query time: 1 msec
;; SERVER: 192.168.50.10#53(192.168.50.10)
;; WHEN: Wed Jul 05 13:58:34 UTC 2023
;; MSG SIZE  rcvd: 96

```
## Задание 2 (Что делали\Причины)
```

Cмотрим тип категории, эта структура: "etc_t" неправильная и меняем тип : sudo chcon -R -t named_zone_t /etc/named

[vagrant@ns01 ~]$ sudo su
[root@ns01 vagrant]# ls -laZ /etc/named
drw-rwx---. root named system_u:object_r:etc_t:s0       .
drwxr-xr-x. root root  system_u:object_r:etc_t:s0       ..
drw-rwx---. root named unconfined_u:object_r:etc_t:s0   dynamic
-rw-rw----. root named system_u:object_r:etc_t:s0       named.50.168.192.rev
-rw-rw----. root named system_u:object_r:etc_t:s0       named.dns.lab
-rw-rw----. root named system_u:object_r:etc_t:s0       named.dns.lab.view1
-rw-rw----. root named system_u:object_r:etc_t:s0       named.newdns.lab
[root@ns01 vagrant]# cat /var/log/audit/audit.log | audit2why
[root@ns01 vagrant]# sudo chcon -R -t named_zone_t /etc/named

[root@ns01 vagrant]# ls -laZ /etc/named
drw-rwx---. root named system_u:object_r:named_zone_t:s0 .
drwxr-xr-x. root root  system_u:object_r:etc_t:s0       ..
drw-rwx---. root named unconfined_u:object_r:named_zone_t:s0 dynamic
-rw-rw----. root named system_u:object_r:named_zone_t:s0 named.50.168.192.rev
-rw-rw----. root named system_u:object_r:named_zone_t:s0 named.dns.lab
-rw-rw----. root named system_u:object_r:named_zone_t:s0 named.dns.lab.view1
-rw-rw----. root named system_u:object_r:named_zone_t:s0 named.newdns.lab


Вводим зону A для клиента

[root@client ~]# nsupdate -k /etc/named.zonetransfer.key
> server 192.168.50.10
> zone ddns.lab
> update add www.ddns.lab. 60 A 192.168.50.15
> send
>  quit 

Проверяем демона DNS "systemctl status service named"

named.service - Berkeley Internet Name Domain (DNS)
   Loaded: loaded (/usr/lib/systemd/system/named.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2023-07-06 17:56:42 UTC; 8s ago
  Process: 5493 ExecStop=/bin/sh -c /usr/sbin/rndc stop > /dev/null 2>&1 || /bin/kill -TERM $MAINPID (code=exited, status=0/SUCCESS)
  Process: 5506 ExecStart=/usr/sbin/named -u named -c ${NAMEDCONF} $OPTIONS (code=exited, status=0/SUCCESS)
  Process: 5504 ExecStartPre=/bin/bash -c if [ ! "$DISABLE_ZONE_CHECKING" == "yes" ]; then /usr/sbin/named-checkconf -z "$NAMEDCONF"; else echo "Checking of zone files is disabled"; fi (code=exited, status=0/SUCCESS)
 Main PID: 5508 (named)
   CGroup: /system.slice/named.service
           └─5508 /usr/sbin/named -u named -c /etc/named.conf
           
           
Смотрим полный журнал journalctl -u named

Jul 06 17:10:18 ns01 named[5226]: managed-keys-zone/view1: Key 20326 for zone . acceptance timer complet
Jul 06 17:10:18 ns01 named[5226]: resolver priming query complete
Jul 06 17:10:18 ns01 named[5226]: managed-keys-zone/default: Key 20326 for zone . acceptance timer compl
Jul 06 17:10:18 ns01 named[5226]: resolver priming query complete
Jul 06 17:28:48 ns01 named[5226]: client @0x7f031003c3e0 192.168.50.15#39342/key zonetransfer.key: view 
Jul 06 17:28:48 ns01 named[5226]: client @0x7f031003c3e0 192.168.50.15#39342/key zonetransfer.key: view 
Jul 06 17:28:48 ns01 named[5226]: /etc/named/dynamic/named.ddns.lab.view1.jnl: create: permission denied
Jul 06 17:28:48 ns01 named[5226]: client @0x7f031003c3e0 192.168.50.15#39342/key zonetransfer.key: view 

Видим ошибку named.ddns.lab.view1.jnl: create: permission denied


Так же в журнале находим еще одну ошибку, только permission deny. То есть файл не имеет разрешения. 
Подключение клиента к этому серверу: client @0x7f031003c3e0 192.168.50.15#39342/key zonetransfer.key: view -its ok
В данном случае нет проблем с соединениями, есть только разрешения.
"/etc/named/dynamic", вероятнее всего, конфиг неправильного типа.

Изменяем тип этой папки: sudo chcon -R -t named_zone_t /etc/named/dynamic и перезапустил службу named

-rw-rw----. named named system_u:object_r:named_zone_t:s0 named.ddns.lab
-rw-rw----. named named system_u:object_r:named_zone_t:s0 named.ddns.lab.view1

Проблема устранена 

● named.service - Berkeley Internet Name Domain (DNS)
   Loaded: loaded (/usr/lib/systemd/system/named.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2023-07-06 17:56:42 UTC; 46s ago
  Process: 5493 ExecStop=/bin/sh -c /usr/sbin/rndc stop > /dev/null 2>&1 || /bin/kill -TERM $MAINPID (code=exited, status=0/SUCCESS)
  Process: 5506 ExecStart=/usr/sbin/named -u named -c ${NAMEDCONF} $OPTIONS (code=exited, status=0/SUCCESS)
  Process: 5504 ExecStartPre=/bin/bash -c if [ ! "$DISABLE_ZONE_CHECKING" == "yes" ]; then /usr/sbin/named-checkconf -z "$NAMEDCONF"; else echo "Checking of zone files is disabled"; fi (code=exited, status=0/SUCCESS)
 Main PID: 5508 (named)
   CGroup: /system.slice/named.service
           └─5508 /usr/sbin/named -u named -c /etc/named.conf

Jul 06 17:56:42 ns01 named[5508]: network unreachable resolving './NS/IN': 2001:500:1::53#53
Jul 06 17:56:42 ns01 named[5508]: network unreachable resolving './DNSKEY/IN': 2001:dc3::35#53
Jul 06 17:56:42 ns01 named[5508]: network unreachable resolving './NS/IN': 2001:dc3::35#53
Jul 06 17:56:42 ns01 named[5508]: network unreachable resolving './DNSKEY/IN': 2001:500:2::c#53
Jul 06 17:56:42 ns01 named[5508]: network unreachable resolving './NS/IN': 2001:500:2::c#53
Jul 06 17:56:42 ns01 named[5508]: managed-keys-zone/default: Key 20326 for zone . acceptance timer complete: key now trusted
Jul 06 17:56:42 ns01 named[5508]: resolver priming query complete
Jul 06 17:56:42 ns01 named[5508]: network unreachable resolving './DNSKEY/IN': 2001:500:2f::f#53
Jul 06 17:56:42 ns01 named[5508]: managed-keys-zone/view1: Key 20326 for zone . acceptance timer complete: key now

Проверяем: 

nsupdate -k /etc/named.zonetransfer.key
> server 192.168.50.10
>  zone ddns.lab
> update add www.ddns.lab. 60 A 192.168.50.15
> send
> quit
its ok changes saved and work.


[root@client ~]# dig www.ddns.lab
; <<>> DiG 9.11.4-P2-RedHat-9.11.4-26.P2.el7_9.13 <<>> www.ddns.lab
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 28177
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;www.ddns.lab.			IN	A

;; ANSWER SECTION:
www.ddns.lab.		60	IN	A	192.168.50.15

;; AUTHORITY SECTION:
ddns.lab.		3600	IN	NS	ns01.dns.lab.

;; ADDITIONAL SECTION:
ns01.dns.lab.		3600	IN	A	192.168.50.10

;; Query time: 0 msec
;; SERVER: 192.168.50.10#53(192.168.50.10)
;; WHEN: Thu Jul 06 18:02:22 UTC 2023
;; MSG SIZE  rcvd: 96

[root@client ~]# dig @192.168.50.10 www.ddns.lab

; <<>> DiG 9.11.4-P2-RedHat-9.11.4-26.P2.el7_9.13 <<>> @192.168.50.10 www.ddns.lab
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 52950
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;www.ddns.lab.			IN	A

;; ANSWER SECTION:
www.ddns.lab.		60	IN	A	192.168.50.15

;; AUTHORITY SECTION:
ddns.lab.		3600	IN	NS	ns01.dns.lab.

;; ADDITIONAL SECTION:
ns01.dns.lab.		3600	IN	A	192.168.50.10

;; Query time: 0 msec
;; SERVER: 192.168.50.10#53(192.168.50.10)
;; WHEN: Thu Jul 06 18:02:39 UTC 2023
;; MSG SIZE  rcvd: 96

// labs ddns zone
    zone "ddns.lab" {
        type master;
        allow-transfer { key "zonetransfer.key"; };
        allow-update { key "zonetransfer.key"; };
        file "/etc/named/dynamic/named.ddns.lab";
    };
```