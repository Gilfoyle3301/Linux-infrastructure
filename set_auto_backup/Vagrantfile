Vagrant.configure("2") do |config|
    config.vm.box = "criptobes3301/ubuntu-20.04"
    config.vm.box_version = "1.0"
    config.vm.define "server" do |server|
      server.vm.network  "private_network", ip: "192.168.56.160"
      server.vm.hostname = "rsyslogServer"  
      server.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
        vb.cpus = 1
        vb.customize ['createhd', '--filename', 'backup.vdi', '--variant', 'Fixed', '--size', '2048']
        vb.customize [ 'storageattach', 
                :id, 
                '--storagectl', 'SATA Controller', 
                '--port', 2, 
                '--device', 0, 
                '--type', 'hdd', 
                '--medium','backup.vdi']
      end
      server.vm.provision "file", source: "./server_pair/", destination: "/home/vagrant/server_pair"
      server.vm.provision "shell", path: "./scripts/server.sh"
    end
  
  
    config.vm.define "client" do |client|
      client.ssh.username = 'vagrant'
      client.ssh.password = 'vagrant'
      client.ssh.insert_key = false
      client.vm.network "private_network", ip: "192.168.56.150"
      client.vm.hostname = "rsyslogClient"  
      client.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
        vb.cpus = 1
      end
      client.vm.provision "file", source: "./client_pair/", destination: "/home/vagrant/client_pair"
      client.vm.provision "file", source: "./units/", destination: "/home/vagrant/units"
      client.vm.provision "shell", path: "./scripts/client.sh"
  
    end
  end