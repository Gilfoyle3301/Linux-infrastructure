# -*- mode: ruby -*-
# vim: set ft=ruby :


MACHINES = {
  :monitoring => {
    :box => "criptobes3301/ubuntu-20.04",
    :version => "1.0", 
    :host_name => "Prometheus-server" 
  }
}


Vagrant.configure("2") do |config|
  MACHINES.each do |boxname, boxconfig|
    config.vm.define boxname do |box|
      box.vm.box = boxconfig[:box]
      box.vm.box_version = boxconfig[:version]
      box.vm.host_name = boxconfig[:host_name]
      
      box.vm.network "forwarded_port", guest: 9090, host: 9090
      box.vm.network "forwarded_port", guest: 3000, host: 3000 
      box.vm.network "forwarded_port", guest: 9100, host: 9100 
      box.vm.network "private_network", ip: "192.168.56.10", virtualbox__intnet: "net1"

      box.vm.provider :virtualbox do |vb|
        vb.memory = "1024"
        vb.cpus = 1
      end
    end
    config.vm.provision "file", source: "./conf", destination: "/home/vagrant/conf"
    config.vm.provision "file", source: "./package", destination: "/home/vagrant/package"
    config.vm.provision "file", source: "./scripts", destination: "/home/vagrant/scripts"
    config.vm.provision "file", source: "./units", destination: "/home/vagrant/units"
    config.vm.provision "shell", path: "./scripts/install.sh"
  end
end
