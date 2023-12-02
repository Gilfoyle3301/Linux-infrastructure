# -*- mode: ruby -*-
# vim: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.provider "virtualbox" do |v|
	  v.memory = 512
    v.cpus = 1
  end
  
  config.vm.define "inetRouter" do |iR|
    iR.vm.box = "generic/centos8"
    iR.vm.network "private_network", adapter: 2, auto_config: false, virtualbox__intnet: "router-net"
    iR.vm.network "private_network", adapter: 3, auto_config: false, virtualbox__intnet: "router-net"
    iR.vm.network "private_network", ip: '192.168.56.10', adapter: 8
    iR.vm.hostname = "inetRouter"
  end


  config.vm.define "centralRouter" do |cR|
    cR.vm.box = "generic/centos8"
    cR.vm.network "private_network", adapter: 2, auto_config: false, virtualbox__intnet: "router-net"
    cR.vm.network "private_network", adapter: 3, auto_config: false, virtualbox__intnet: "router-net"
    cR.vm.network "private_network", ip: '192.168.255.9', adapter: 6, netmask: "255.255.255.252", virtualbox__intnet: "office1-central"
    cR.vm.network "private_network", ip: '192.168.56.11', adapter: 8
    cR.vm.hostname = "centralRouter"
  end

  config.vm.define "office1Router" do |o1R|
    o1R.vm.box = "generic/centos8"
    o1R.vm.network "private_network", ip: '192.168.255.10', adapter: 2, netmask: "255.255.255.252", virtualbox__intnet: "office1-central"
    o1R.vm.network "private_network", adapter: 3, auto_config: false, virtualbox__intnet: "vlan1"
    o1R.vm.network "private_network", adapter: 4, auto_config: false, virtualbox__intnet: "vlan1"
    o1R.vm.network "private_network", adapter: 5, auto_config: false, virtualbox__intnet: "vlan2"
    o1R.vm.network "private_network", adapter: 6, auto_config: false, virtualbox__intnet: "vlan2"
    o1R.vm.network "private_network", ip: '192.168.56.20', adapter: 8
    o1R.vm.hostname = "office1Router"
  end

  config.vm.define "testClient1" do |t1C|
    t1C.vm.box = "generic/centos8"
    t1C.vm.network "private_network", adapter: 2, auto_config: false, virtualbox__intnet: "testLAN"
    t1C.vm.network "private_network", ip: '192.168.56.21'
    t1C.vm.hostname = "testClient1"
  end

  config.vm.define "testServer1" do |t1S|
    t1S.vm.box = "generic/centos8"
    t1S.vm.network "private_network", adapter: 2, auto_config: false, virtualbox__intnet: "testLAN"
    t1S.vm.network "private_network", ip: '192.168.56.22'
    t1S.vm.hostname = "testServer1"
  end

  config.vm.define "testClient2" do |t1S|
    t1S.vm.box = "criptobes3301/ubuntu-20.04"
    t1S.vm.network "private_network", adapter: 2, auto_config: false, virtualbox__intnet: "testLAN"
    t1S.vm.network "private_network", ip: '192.168.56.31'
    t1S.vm.hostname = "testClient2"
  end

  config.vm.define "testServer2" do |t1S|
    t1S.vm.box = "criptobes3301/ubuntu-20.04"
    t1S.vm.network "private_network", adapter: 2, auto_config: false, virtualbox__intnet: "testLAN"
    t1S.vm.network "private_network", ip: '192.168.56.32'
    t1S.vm.hostname = "testServer2"
  end

  config.vm.provision "shell", inline: <<-SHELL
    mkdir -p ~root/.ssh
    cp ~vagrant/.ssh/auth* ~root/.ssh
  SHELL

end