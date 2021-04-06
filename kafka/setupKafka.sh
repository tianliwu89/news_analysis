#!/bin/bash
# install nessarry packages
sudo apt-get update && sudo apt-get -y install wget zip tar git
# install java
sudo apt-get -y install default-jdk

#install python
sudo apt-get install -y python3 python3-pip

# install kafka managment
# # isntall scala
# wget www.scala-lang.org/files/archive/scala-2.13.0.deb
# sudo dpkg -i scala*.deb

# # Install SBT
# echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
# sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
# sudo apt-get install sbt

#  install kafka
sudo sysctl vm.swappiness=1
echo 'vm.swappiness=1' | sudo tee --append /etc.sysctl.conf
wget https://mirrors.ocf.berkeley.edu/apache/kafka/2.7.0/kafka_2.13-2.7.0.tgz
tar -xzf kafka_2.13-2.7.0.tgz
rm kafka_2.13-2.7.0.tgz

# run zookeeper and kafka server
KAFKA_DNS=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/hostname"   -H "Metadata-Flavor: Google")
sudo sed -i "s+#advertised.listeners=PLAINTEXT://your.host.name:9092+advertised.listeners=PLAINTEXT://$KAFKA_DNS:9092+g" $(pwd)/kafka_2.13-2.7.0/config/server.properties
sudo $(pwd)/kafka_2.13-2.7.0/bin/zookeeper-server-start.sh $(pwd)/kafka_2.13-2.7.0/config/zookeeper.properties &
sudo $(pwd)/kafka_2.13-2.7.0/bin/kafka-server-start.sh $(pwd)/kafka_2.13-2.7.0/config/server.properties &
