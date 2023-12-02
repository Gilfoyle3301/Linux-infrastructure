# -*- mode: ruby -*-
# vim: set ft=ruby :


MACHINES = {
  :Lab_PAM => {
    :box => "criptobes3301/ubuntu-20.04",
    :version => "1.0", 
    :host_name => "PAMLab",
    :memory => "1024",
    :cpus => "1",
    :ip => "192.168.56.10"

  }
}


Vagrant.configure("2") do |config|
  MACHINES.each do |boxname, boxconfig|
    config.vm.define boxname do |box|
      box.vm.box = boxconfig[:box]
      box.vm.box_version = boxconfig[:version]
      box.vm.host_name = boxconfig[:host_name]
      
      box.vm.network "private_network", ip: boxconfig[:ip]

      box.vm.provider :virtualbox do |vb|
        vb.memory = boxconfig[:memory]
        vb.cpus = boxconfig[:cpus]
      end
    end
    config.vm.provision "file", source: "./scripts/pam_script.sh", destination: "/home/vagrant/scripts"
    config.vm.provision "shell", path: "./scripts/run.sh"
  end
end
