# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

MACHINES = {
  :otus_zfs => {
    :box_name => "otus-zfs",
    :box => "criptobes3301/ubuntu-20.04",
    :version => "1.0",
    :disk => {
      :disk2 => {
        :dfile => '../disk-2.vdi',
        :size => 1024, 
        :port => 2
      },
      :disk3 => {
        :dfile => '../disk-3.vdi',
        :size => 1024, 
        :port => 3
      },
      :disk4 => {
        :dfile => '../disk-4.vdi',
        :size => 1024, 
        :port => 4
      },
      :disk5 => {
        :dfile => '../disk-5.vdi',
        :size => 1024, 
        :port => 5
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
    config.vm.provision "shell", path: "./scripts/createZFS.sh"

end
