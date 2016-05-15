#!/bin/bash
set -e
if [ -n $DATA_EXIM_API_KEY ]; then
	api_key=$DATA_EXIM_API_KEY
fi

if [ -n $DATA_EXIM_SECRET_KEY ]; then
	secret_key=$DATA_EXIM_SECRET_KEY
fi

host_name=$HOSTNAME

if [ ! $host_name ]; then
        printf "HOSTNAME env variable shouldn't be empty\n"
        exit 1;
fi

host_id=`cat /etc/data_exim_collector/collector.conf | grep host_id | awk -F '=' '{print $2}'`

if [! $host_id ];then
	host_id=$(curl -sb -H "http://146.148.19.93:8888/v1.0/metrics/host_id/$secret_key/$api_key/$host_name/")
fi

echo $host_id

if [ ! $api_key ]; then
	printf "Please set DATA_EXIM_API_KEY evironment variable\n"
	exit 1;
fi

if [ ! $secret_key ]; then
        printf "Please set DATA_EXIM_SECRET_KEY evironment variable\n"
        exit 1;
fi

if [ ! $host_id ]; then
	printf "Couldn't get host_id\n"
	exit 1;
fi


sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 891251DA
sudo add-apt-repository "deb http://104.155.109.157/ trusty main"
sudo apt-get update
sudo apt-get install -y python-data-exim python-requests metric-collector
sudo apt-get install -f -y

sudo sed -i "s,api_key=.*,api_key=$api_key," /etc/data_exim_collector/collector.conf
sudo sed -i "s,secret_key=.*,secret_key=$secret_key," /etc/data_exim_collector/collector.conf
sudo sed -i "s,host_id=.*,host_id=$host_id," /etc/data_exim_collector/collector.conf
sudo service metric-collector restart
