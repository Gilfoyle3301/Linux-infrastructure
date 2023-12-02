# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "criptobes3301/ubuntu-20.04"
  config.vm.box_version = "1.0"
  config.vm.define "server" do |server|
    server.vm.network  "public_network", ip: "192.168.1.160"
    server.vm.hostname = "otus-server-nfs"  
    server.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 1
    end
    server.vm.provision "shell", path:"./scriptnfs/createNFS.sh"
  end


  config.vm.define "client" do |client|
    client.vm.network "public_network", ip: "192.168.1.161"
    client.vm.hostname = "otus-client-nfs"  
    client.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 1
    end
    client.vm.provision "shell", path:"./scripts/nfsclient.sh"
  end
end