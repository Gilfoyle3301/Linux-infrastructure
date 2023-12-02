sudo apt update
sudo apt install dpkg-dev devscripts equivs wget -y
sudo  wget https://nginx.org/download/nginx-1.25.0.tar.gz
tar xzfv nginx-1.25.0.tar.gz
cd nginx-1.25.0/
sudo wget https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.42/pcre2-10.42.tar.gz
sudo tar xzfv pcre2-10.42.tar.gz 
sudo wget http://zlib.net/zlib-1.2.13.tar.gz
sudo tar xzfv zlib-1.2.13.tar.gz 
sudo  ./configure --sbin-path=/src/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --with-pcre=./pcre2-10.42/ --pid-path=/var/run/nginx.pid --with-zlib=./zlib-1.2.13
sudo make
sudo make install
sudo touch /lib/systemd/system/nginx.service
sudo chmod o+x /lib/systemd/system/nginx.service
cat << EOF >> /lib/systemd/system/nginx.service
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/var/run/nginx.pid
ExecStartPre=/src/sbin/nginx -t
ExecStart=/src/sbin/nginx
ExecReload=/src/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target

EOF
    
sudo chmod o-x /lib/systemd/system/nginx.service
sudo systemctl daemon-reload
sudo systemctl start nginx
curl 127.0.0.1 -p 80

zlib1g-dev
pcre2-utils