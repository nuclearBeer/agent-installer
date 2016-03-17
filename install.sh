#!/bin/sh
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 891251DA
sudo add-apt-repository "deb http://104.155.109.157/ trusty main"
sudo apt-get update
sudo apt-get install python-data-exim metric-collector
sudo apt-get install -f --yes
sudo touch /var/run/metric-collector.pid
sudo sed -i.bak 's/^\(api_key=\).*/\1$DATA_EXIM_API_KEY/' /etc/data_exim_collector/collector.conf
sudo sed -i.bak 's/^\(secret_key=\).*/\1$DATA_EXIM_SECRET_KEY/' /etc/data_exim_collector/collector.conf
sudo service metric-collector start
