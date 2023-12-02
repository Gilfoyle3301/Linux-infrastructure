# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
  :backupServer => {
    :box_name => "criptobes3301/ubuntu-20.04",
    :ip_addr => '192.168.77.18',
    :cpus => 2,
    :memory => 1024,
    :playbooks_name => "backup",
  },
  :serverDNS => {
    :box_name => "criptobes3301/ubuntu-20.04",
    :ip_addr => '192.168.77.11',
    :cpus => 2,
    :memory => 512,
    :playbooks_name => "dns",
  },
  :frontServer => {
    :box_name => "criptobes3301/ubuntu-20.04",
    :ip_addr => '192.168.77.10',
    :cpus => 2,
    :memory => 512,
    :playbooks_name => "nginx",
  },
  :applicationServer => {
    :box_name => "criptobes3301/ubuntu-20.04",
    :ip_addr => '192.168.77.14',
    :cpus => 2,
    :memory => 512,
    :playbooks_name => "app",
  },
  :applicationSlave => {
    :box_name => "criptobes3301/ubuntu-20.04",
    :ip_addr => '192.168.77.15',
    :cpus => 2,
    :memory => 512,
    :playbooks_name => "appSlave",
  },
  :logServer => {
    :box_name => "criptobes3301/ubuntu-20.04",
    :ip_addr => '192.168.77.13',
    :cpus => 2,
    :memory => 512,
    :playbooks_name => "logs",
  },
  :dataBaseServer => {
    :box_name => "criptobes3301/ubuntu-20.04",
    :ip_addr => '192.168.77.16',
    :cpus => 2,
    :memory => 512,
    :playbooks_name => "database",
  },
  :dataBaseSlave => {
    :box_name => "criptobes3301/ubuntu-20.04",
    :ip_addr => '192.168.77.17',
    :cpus => 2,
    :memory => 1024,
    :playbooks_name => "databaseSlave",
  },
  :monitoringServer => {
    :box_name => "criptobes3301/ubuntu-20.04",
    :ip_addr => '192.168.77.12',
    :cpus => 2,
    :memory => 512,
    :playbooks_name => "monitoring",
  }
}

Vagrant.configure("2") do |config|
  MACHINES.each do |boxname, boxconfig|
      config.vm.define boxname do |box|
          box.vm.box = boxconfig[:box_name]
          box.vm.host_name = boxname.to_s + ".security.lab"

          if boxname.to_s == "frontServer"
            box.vm.network "forwarded_port", guest: 443, host: 443
          end
          
          if boxname.to_s == 'monitoringServer'
            box.vm.network "forwarded_port", guest: 9090, host: 9090
            box.vm.network "forwarded_port", guest: 3000, host: 3000 
            box.vm.network "forwarded_port", guest: 9100, host: 9100 
          end

          box.vm.network "private_network", ip: boxconfig[:ip_addr], virtualbox__intnet: "DMZ"
          box.vm.provision "ansible" do |ansible|
            ansible.verbose = ""
            ansible.playbook = "ansible/playbooks/" + boxconfig[:playbooks_name] + ".yml"
          end
          box.vm.provider :virtualbox do |vb|
            vb.memory = boxconfig[:memory]
            vb.cpus = boxconfig[:cpus] 	        
          end
      end
  end
end
