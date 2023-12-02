# -*- mode: ruby -*-
# vim: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "criptobes3301/ubuntu-20.04"
  config.vm.box_version = '1.0'
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "conf/playbook.yml"
    ansible.sudo = "true"
  end


  config.vm.provider "virtualbox" do |v|
	  v.memory = 512
    v.cpus = 1
  end

  config.vm.define "ns01" do |ns01|
    ns01.vm.network "private_network", ip: "192.168.50.10", virtualbox__intnet: "dns"
    ns01.vm.hostname = "ns01"
  end

  config.vm.define "ns02" do |ns02|
    ns02.vm.network "private_network", ip: "192.168.50.11", virtualbox__intnet: "dns"
    ns02.vm.hostname = "ns02"
  end

  config.vm.define "client" do |client|
    client.vm.network "public_network", ip: "192.168.56.160"
    client.vm.network "private_network", ip: "192.168.50.15", virtualbox__intnet: "dns"
    client.vm.hostname = "client"
  end
  config.vm.define "client2" do |client|
    client.vm.network "public_network", ip: "192.168.56.162"
    client.vm.network "private_network", ip: "192.168.50.16", virtualbox__intnet: "dns"
    client.vm.hostname = "client2"
  end
end