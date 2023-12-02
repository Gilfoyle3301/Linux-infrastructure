
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "criptobes3301/ubuntu-20.04"
  config.vm.box_version = "1.0"
  config.vm.define "server" do |server|
    server.vm.network  "public_network", ip: "192.168.1.160"
    server.vm.hostname = "otus-server-nfs"  
    server.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 1
    end
    server.vm.provision "file", source: "./app", destination: "/home/vagrant/app"
    server.vm.provision "file", source: "./inventory", destination: "/home/vagrant/inventory"
    server.vm.provision "file", source: "./ansible.cfg", destination: "/home/vagrant/ansible.cfg"
    server.vm.provision "file", source: "./ssl/id_rsa", destination: "/home/vagrant/.ssh/id_rsa"
    server.vm.provision "file", source: "./ssl/id_rsa.pub", destination: "/home/vagrant/.ssh/id_rsa.pub"
    server.vm.provision "shell", inline: <<-SHELL
    sudo apt update
    sudo apt install ansible -y
    sudo chmod 0600 /home/vagrant/.ssh/id_rsa
    SHELL
  end


  config.vm.define "client" do |client|
    client.vm.network "public_network", ip: "192.168.1.161"
    client.vm.network "public_network", ip6: "2001:0db8:85a3:0000:0000:8a2e:0370:7334"
    client.vm.hostname = "otus-client-nfs"  
    client.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 1
    end
    client.vm.provision "file", source: "./ssl/id_rsa.pub", destination: "/home/vagrant/"
    client.vm.provision "file", source: "./ssl/nginx.crt", destination: "/home/vagrant/"
    client.vm.provision "file", source: "./ssl/nginx.key", destination: "/home/vagrant/"
    client.vm.provision "file", source: "./conf/ng.conf", destination: "/home/vagrant/"
    client.vm.provision "shell", inline: <<-SHELL
    sudo cat /home/vagrant/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
    sudo mkdir -p /etc/nginx/ssl/
    sudo cp nginx* /etc/nginx/ssl/
    sudo mkdir -p /etc/nginx/sites-available/
    sudo cp /home/vagrant/ng.conf  /etc/nginx/sites-available/default
    SHELL
  end
end