# -*- mode: ruby -*-
# vim: set ft=ruby :
home = ENV['HOME']
ENV["LC_ALL"] = "en_US.UTF-8"

  # ========================================= InetRouter ========================================

Vagrant.configure(2) do |config|
  config.vm.define "router1" do |router1|
    router1.vm.box = "criptobes3301/ubuntu-20.04"
    router1.vm.box_version = '1.0'
    router1.vm.provider "virtualbox" do |vb|
      vb.name = "Router1"
      vb.memory = "1024"
      vb.cpus = 1
    end
    router1.vm.hostname = "Router1"
    router1.vm.network "private_network", ip: "10.0.10.1", adapter: 2, netmask: "255.255.255.252", virtualbox__intnet: "r1-r2"
    router1.vm.network "private_network", ip: "10.0.12.1", adapter: 3, netmask: "255.255.255.252", virtualbox__intnet: "r1-r3"
    router1.vm.network "private_network", ip: "192.168.10.1", adapter: 4, netmask: "255.255.255.0", virtualbox__intnet: "net1"
    router1.vm.network "private_network", ip: "192.168.56.10", adapter: 5
  end
end

Vagrant.configure(2) do |config|
  config.vm.define "router2" do |router2|
    router2.vm.box = "criptobes3301/ubuntu-20.04"
    router2.vm.box_version = '1.0'
    router2.vm.provider "virtualbox" do |vb|
      vb.name = "Router2"
      vb.memory = "1024"
      vb.cpus = 1
    end
    router2.vm.hostname = "Router2"
    router2.vm.network "private_network", ip: "10.0.10.2", adapter: 2, netmask: "255.255.255.252", virtualbox__intnet: "r1-r2"
    router2.vm.network "private_network", ip: "10.0.11.2", adapter: 3, netmask: "255.255.255.252", virtualbox__intnet: "r2-r3"
    router2.vm.network "private_network", ip: "192.168.20.1", adapter: 4, netmask: "255.255.255.0", virtualbox__intnet: "net2"
    router2.vm.network "private_network", ip: "192.168.56.11", adapter: 5
  end
end

Vagrant.configure(2) do |config|
  config.vm.define "router3" do |router3|
    router3.vm.box = "criptobes3301/ubuntu-20.04"
    router3.vm.box_version = '1.0'
    router3.vm.provider "virtualbox" do |vb|
      vb.name = "Router3"
      vb.memory = "1024"
      vb.cpus = 1
    end
    router3.vm.provision "ansible" do |ansible|
      ansible.playbook = "ansible/provision.yml"
      ansible.inventory_path = "inventory/hosts"
      ansible.host_key_checking = "false"
      ansible.limit = "all"
    end
    router3.vm.hostname = "Router3"
    router3.vm.network "private_network", ip: "10.0.11.1", adapter: 2, netmask: "255.255.255.252", virtualbox__intnet: "r2-r3"
    router3.vm.network "private_network", ip: "10.0.12.2", adapter: 3, netmask: "255.255.255.252", virtualbox__intnet: "r1-r3"
    router3.vm.network "private_network", ip: "192.168.30.1", adapter: 4, netmask: "255.255.255.0", virtualbox__intnet: "net3"
    router3.vm.network "private_network", ip: "192.168.56.12", adapter: 5
  end
end