# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

MACHINES = {
  :otus => {
    :box_name => "otus",
    :box => "criptobes3301/ubuntu-20.04",
    :version => "1.0",
    :disk => {
      :disk2 => {
        :dfile => '../disk-2.vdi',
        :size => 4096, 
        :port => 2
      },
      :disk3 => {
        :dfile => '../disk-3.vdi',
        :size => 4096, 
        :port => 3
      },
      :disk4 => {
        :dfile => '../disk-4.vdi',
        :size => 4096, 
        :port => 4
      }

    }

  },

}



Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  MACHINES.each do |boxname, boxconfig|
    config.vm.define boxname do |box|
      box.vm.hostname = boxconfig[:box_name]
      box.vm.box = boxconfig[:box]
      box.vm.box_version = boxconfig[:version]
      box.vm.network "public_network"
      box.vm.provider :virtualbox do |vb|
        vb.memory = "1024"
        vb.cpus = 1
        boxconfig[:disk].each do |dname, dconf|
          vb.customize ['createhd', '--filename', dconf[:dfile], '--variant', 'Fixed', '--size', dconf[:size]]
          vb.customize [ 'storageattach', 
                :id, 
                '--storagectl', 'SATA Controller', 
                '--port', dconf[:port], 
                '--device', 0, 
                '--type', 'hdd', 
                '--medium', dconf[:dfile]]
        end     
      end
    end
  end
end
