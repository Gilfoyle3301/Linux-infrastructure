# -*- mode: ruby -*-
# vim: set ft=ruby :


MACHINES = {
  :selinux => {
        :box_name => "centos/7",
        :box_version => "2004.01",
        #:provision => "test.sh",       
  },
}


Vagrant.configure("2") do |config|
  MACHINES.each do |boxname, boxconfig|
      config.vm.define boxname do |box|
        box.vm.box = boxconfig[:box_name]
        box.vm.box_version = boxconfig[:box_version]
        box.vm.host_name = "otus-selinux"
        box.vm.network "forwarded_port", guest: 5678, host: 5678
        box.vm.provider :virtualbox do |vb|
              vb.customize ["modifyvm", :id, "--memory", "1024"]
              needsController = false
        end
        box.vm.provision "shell", inline: <<-SHELL
          yum install -y epel-release
          yum install -y nginx
          sed -ie 's/:80/:5678/g' /etc/nginx/nginx.conf
          sed -i 's/listen       80;/listen       5678;/' /etc/nginx/nginx.conf
          systemctl start nginx
          systemctl status nginx
          ss -tlpn | grep 5678
        SHELL
    end
  end
end
