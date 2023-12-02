Vagrant.configure("2") do |config|
    config.vm.box = "criptobes3301/ubuntu-20.04"
    config.vm.box_version = "1.0"
    config.vm.disk :disk, size: "20GB", primary: true
    config.vm.define "server" do |server|
      server.vm.disk :disk, size: "20GB", name: "extra_storage1"
      server.vm.network  :private_network, ip: "192.168.56.160", virtualbox__intnet: 'pxenet'
      server.vm.network "forwarded_port", guest: 80, host: 8081
      server.vm.hostname = "PXEServer"  
      server.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
        vb.cpus = 1
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"] 
      end
      config.vm.provision "shell", path: "./scripts/install.sh"
    end
  
  
    config.vm.define "client" do |client|
      client.vm.network :private_network, ip: "192.168.56.150"
      client.vm.hostname = "PXEClient"  
      client.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
        vb.cpus = 1
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        vb.customize [
            'modifyvm', :id,
            '--nic1', 'intnet',
            '--intnet1', 'pxenet',
            '--nic2', 'nat',
            '--boot1', 'net',
            '--boot2', 'none',
            '--boot3', 'none',
            '--boot4', 'none'
            ]
      end
    end
  end