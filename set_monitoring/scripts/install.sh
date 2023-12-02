#!/bin/bash

#Setup prometheus
sudo apt update
wget https://github.com/prometheus/prometheus/releases/download/v2.46.0/prometheus-2.46.0.linux-amd64.tar.gz
tar -xzf prometheus-*.tar.gz
sudo mkdir /etc/prometheus/
sudo mkdir /var/lib/prometheus/
sudo cp -a /home/vagrant/prometheus-2.46.0.linux-amd64/prometheus /etc/prometheus/
sudo cp -a /home/vagrant/prometheus-2.46.0.linux-amd64/prometheus /usr/local/bin
sudo cp -a /home/vagrant/prometheus-2.46.0.linux-amd64/promtool /usr/local/bin
sudo cp -r /home/vagrant/prometheus-2.46.0.linux-amd64/consoles /etc/prometheus
sudo cp -r /home/vagrant/prometheus-2.46.0.linux-amd64/console_libraries /etc/prometheus
sudo useradd --no-create-home --shell /bin/false prometheus
sudo cp /home/vagrant/units/prometheus.service /etc/systemd/system/prometheus.service
sudo cp /home/vagrant/conf/prometheus.yml /etc/prometheus/prometheus.yml
sudo chmod 644 /etc/systemd/system/prometheus.service
sudo chmod 644 /etc/systemd/system/prometheus.service
sudo chmod 644 /etc/prometheus/prometheus.yml
sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown -R prometheus:prometheus /var/lib/prometheus
sudo chown -R prometheus:prometheus /usr/local/bin/prom*
sudo systemctl daemon-reload
sudo systemctl start prometheus

#Setup node exporter
wget  https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz
sudo groupadd -f node_exporter
sudo useradd -g node_exporter --no-create-home --shell /bin/false node_exporter
sudo mkdir /etc/node_exporter
sudo chown node_exporter:node_exporter /etc/node_exporter
tar -xvf node_exporter-1.6.1.linux-amd64.tar.gz
sudo cp node_exporter-1.6.1.linux-amd64/node_exporter /usr/bin/
sudo chown node_exporter:node_exporter /usr/bin/node_exporter
sudo cp /home/vagrant/units/node_exporter.service /usr/lib/systemd/system/node_exporter.service
sudo chmod 664 /usr/lib/systemd/system/node_exporter.service
sudo systemctl daemon-reload
sudo systemctl start node_exporter

#Setup Grafana
sudo apt-get install -y adduser libfontconfig1
sudo apt --fix-broken install -y
sudo dpkg -i /home/vagrant/package/grafana-enterprise_10.0.3_amd64.deb
sudo systemctl start grafana-server

#import Dashboard
curl --user admin:admin "localhost:3000/api/dashboards/db" -X POST -H "Content-Type:application/json;charset=UTF-8" --data-binary /home/vagrant/conf/dasboard.json