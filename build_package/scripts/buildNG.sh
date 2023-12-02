sudo apt update
sudo apt install dpkg-dev devscripts equivs wget libpcre3-dev zlib1g-dev -y
mkdir ./debian
mkdir /var/otus_repo
echo "deb [trusted=yes] file:/var/otus_repo ./" >> /etc/apt/sources.list
cat << EOF >> ./debian/rules
#!/usr/bin/make -f
export DH_VERBOSE = 1

url='https://nginx.org/download/nginx-1.25.0.tar.gz'
build_dir='nginx'

override_dh_auto_clean:
	if [ ! -f \$(build_dir) ]; then rm -rf \$(build_dir); fi
	mkdir \$(build_dir)
	dh_auto_clean

override_dh_auto_configure:
	wget \$(url) -O \$(build_dir).tar.gz
	tar -xzf \$(build_dir).tar.gz -C \$(build_dir)/ --strip-components=1
	rm -f \$(build_dir).tar.gz
	cd \$(build_dir) && ./configure

override_dh_usrlocal:

%:
	dh \$@ --sourcedirectory=\$(build_dir)/
EOF
cat << EOF >> ./debian/control
Source:                 nginx
Section:                misc
Priority:               optional
Maintainer:             Gilfoyle <otus@gmail.com>
Build-Depends:          libpcre3-dev,
                        zlib1g-dev
Standards-Version:      1.25.0
Homepage:               https://nginx.org

Package:                nginx
Architecture:           amd64
Provides:               nginx
Description: NGINX packages.
 The description can be written in several lines.
 Each line have to be 73 chars maximum.
EOF

echo "9" > ./debian/compat

cat << EOF >> ./debian/changelog
nginx (1.25.0) stable; urgency=medium
  * Initial release
 -- Gilfoyle <otus@gmail,com>  Tue, 28 May 2023 17:34:42 +0300
EOF

sudo debuild -us -uc -b
sudo cp ../nginx_1.25.0_amd64.deb /var/otus_repo
cd /var/otus_repo
sudo dpkg-scanpackages . /dev/null > Release
sudo dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz

sudo sudo apt update 
sudo apt search nginx| grep "1.25"
