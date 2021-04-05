#!/bin/bash
sudo apt-get update && sudo apt-get -y install wget ca-certificates zip net-tools tar netcat
sudo apt-get -y install default-jdk
sudo apt-get -y install git
sudo sysctl vm.swappiness=1
echo 'vm.swappiness=1' | sudo tee --append /etc.sysctl.conf
wget https://mirrors.ocf.berkeley.edu/apache/kafka/2.7.0/kafka_2.13-2.7.0.tgz
tar -xzf kafka_2.13-2.7.0.tgz
rm kafka_2.13-2.7.0.tgz
mv kafka_2.13-2.7.0 kafka
