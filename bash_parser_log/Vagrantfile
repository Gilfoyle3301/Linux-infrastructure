# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "criptobes3301/ubuntu-20.04"
  config.vm.box_version = "1.0"
  config.vm.define "admin" do |admin|
    admin.vm.network  "public_network", ip: "192.168.1.160"
    admin.vm.hostname = "otus-bilder-app"  
    admin.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
        vb.cpus = 1
      end
    end
    config.vm.provision "file", source: "access.log", destination: "/tmp/access.log"
    config.vm.provision "file", source: "error.log", destination: "/tmp/error.log"
    config.vm.provision "file", source: "parse.sh", destination: "/home/vagrant/parse.sh"
    config.vm.provision "shell", inline: <<-SHELL
    sudo timedatectl set-ntp off
    timedatectl set-time "2023-06-17 5:21:37"
    sudo chmod 777 /etc/crontab
    sudo echo "0 * * * *  /home/vagrant/parse.sh -xn /var/lock/parse.lock -c 'sh /home/vagrant/parse.sh'" >> /etc/crontab
    sudo chmod 644 /etc/crontab
    sudo apt update
    SHELL
end