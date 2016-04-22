#!/bin/bash
set -e
if [ -n $DATA_EXIM_API_KEY ]; then
	api_key=$DATA_EXIM_API_KEY
fi

if [ -n $DATA_EXIM_SECRET_KEY ]; then
	secret_key=$DATA_EXIM_SECRET_KEY
fi

response=$(curl -sb -H "http://146.148.19.93:8888/v1.0/metrics/host_id/$secret_key/$api_key/")
echo $response

if [ ! $api_key ]; then
	printf "Please set DATA_EXIM_API_KEY evironment variable"
	exit 1;
fi

if [ ! $secret_key ]; then
        printf "Please set DATA_EXIM_SECRET_KEY evironment variable"
        exit 1;
fi

if [ ! $host_id ]; then
	printf "Couldn't get host_id"
	exit 2;
fi
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 891251DA
sudo add-apt-repository "deb http://104.155.109.157/ trusty main"
sudo apt-get update
sudo apt-get install -y python-data-exim metric-collector
sudo apt-get install -f -y
sudo touch /var/run/metric-collector.pid

sudo sed -i "s,api_key=.*,api_key=$api_key," /etc/data_exim_collector/collector.conf
sudo sed -i "s,secret_key=.*,secret_key=$secret_key," /etc/data_exim_collector/collector.conf
sudo sed -i "s,host_id=.*,host_id=$host_id," /etc/data_exim_collector/collector.conf
sudo service metric-collector restart
