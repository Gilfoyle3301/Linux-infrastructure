Vagrant.configure("2") do |config|
    config.vm.box = "criptobes3301/ubuntu-20.04"
    config.vm.box_version = "1.0"
    config.vm.define "server" do |server|
      server.vm.network  "private_network", ip: "192.168.56.15"
      server.vm.hostname = "rsyslogServer"  
      server.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
        vb.cpus = 1
      end
      server.vm.provision "shell", path: "./scripts/server.sh"
    end
  
  
    config.vm.define "client" do |client|
      client.vm.network "private_network", ip: "192.168.56.10"
      client.vm.hostname = "rsyslogClient"  
      client.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
        vb.cpus = 1
      end
      client.vm.provision "file", source: "./scripts/ng.conf", destination: "/home/vagrant/ng.conf"
      client.vm.provision "shell", path: "./scripts/client.sh"
  
    end
  end