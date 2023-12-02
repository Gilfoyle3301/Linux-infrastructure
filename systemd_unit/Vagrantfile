# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "criptobes3301/ubuntu-20.04"
  config.vm.box_version = "1.0"
  config.vm.define "bilder" do |bilder|
      bilder.vm.network  "public_network", ip: "192.168.1.160"
      bilder.vm.hostname = "otus-bilder-app"  
      bilder.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
        vb.cpus = 1
      end
    end
    config.vm.provision "shell", path: "./scripts/runUnit.sh"
end