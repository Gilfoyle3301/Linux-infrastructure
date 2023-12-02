# -*- mode: ruby -*-
# vim: set ft=ruby :
home = ENV['HOME']
ENV["LC_ALL"] = "en_US.UTF-8"

  # ========================================= InetRouter ========================================

Vagrant.configure(2) do |config|
  config.vm.define "server-master" do |router1|
    router1.vm.box = "criptobes3301/ubuntu-20.04"
    router1.vm.box_version = '1.0'
    router1.vm.provider "virtualbox" do |vb|
      vb.name = "server-master"
      vb.memory = "1024"
      vb.cpus = 1
    end
    router1.vm.hostname = "server-master"
    router1.vm.network "private_network", ip: "192.168.56.10", adapter: 5
  end
end

Vagrant.configure(2) do |config|
  config.vm.define "server-slave" do |router2|
    router2.vm.box = "criptobes3301/ubuntu-20.04"
    router2.vm.box_version = '1.0'
    router2.vm.provider "virtualbox" do |vb|
      vb.name = "server-slave"
      vb.memory = "1024"
      vb.cpus = 1
    end
    router2.vm.hostname = "server-slave"
    router2.vm.network "private_network", ip: "10.15.122.20", adapter: 5
  end
end
