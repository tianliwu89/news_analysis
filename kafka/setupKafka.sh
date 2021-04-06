#!/bin/bash
################################
#                              #
#  Install necessary packages  #
#                              #
################################

sudo apt-get update && sudo apt-get -y install wget zip tar git
# install java
sudo apt-get -y install default-jdk
#install python
sudo apt-get install -y python3 python3-pip

sudo sysctl vm.swappiness=1
echo 'vm.swappiness=1' | sudo tee --append /etc.sysctl.conf
wget https://mirrors.ocf.berkeley.edu/apache/kafka/2.7.0/kafka_2.13-2.7.0.tgz
tar -xzf kafka_2.13-2.7.0.tgz
rm kafka_2.13-2.7.0.tgz


###########################################
#                                         #
#  run zookerper server and kafka server  #
#                                         #
###########################################
# get internal ip
KAFKA_DNS=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/hostname"   -H "Metadata-Flavor: Google")
# get external ip
#KAFKA_DNS=$(curl -H "Metadata-Flavor: Google" http://169.254.169.254/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)
if [ "$PWD" = "/" ]; then
	sudo sed -i "s+#advertised.listeners=PLAINTEXT://your.host.name:9092+advertised.listeners=PLAINTEXT://$KAFKA_DNS:9092+g" kafka_2.13-2.7.0/config/server.properties
	sudo kafka_2.13-2.7.0/bin/zookeeper-server-start.sh kafka_2.13-2.7.0/config/zookeeper.properties & disown
	sudo kafka_2.13-2.7.0/bin/kafka-server-start.sh kafka_2.13-2.7.0/config/server.properties & disown
else
	sudo sed -i "s+#advertised.listeners=PLAINTEXT://your.host.name:9092+advertised.listeners=PLAINTEXT://$KAFKA_DNS:9092+g" $(pwd)/kafka_2.13-2.7.0/config/server.properties
	sudo $(pwd)/kafka_2.13-2.7.0/bin/zookeeper-server-start.sh $(pwd)/kafka_2.13-2.7.0/config/zookeeper.properties & disown
	sudo $(pwd)/kafka_2.13-2.7.0/bin/kafka-server-start.sh $(pwd)/kafka_2.13-2.7.0/config/server.properties & disown
fi
