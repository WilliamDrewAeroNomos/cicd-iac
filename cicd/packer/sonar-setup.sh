#!/bin/bash
echo "Executing base image setup"

START_TIMESTAMP=`date +"%Y-%m-$d %T"`
echo Start time : ${START_TIMESTAMP}

yum install sudo -y

echo "Update the image to the latest patches"
sudo amazon-linux-extras install epel -y
sudo yum update -y

echo "Remove java 1.7..."
sudo yum erase java-1.7.0* -y

#############################
echo "Install Java 1.8.0..."
#############################

sudo yum install java-1.8.0-openjdk.x86_64 -y

sudo cp /etc/profile /etc/profile_backup
echo 'export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk' | sudo tee -a /etc/profile
echo 'export JRE_HOME=/usr/lib/jvm/jre' | sudo tee -a /etc/profile
source /etc/profile

echo $JAVA_HOME
echo $JRE_HOME

#############################
echo "Install Sonar..."
#############################

sudo yum -y install sudo vim wget unzip net-tools

sudo wget -O /etc/yum.repos.d/sonar.repo http://downloads.sourceforge.net/project/sonar-pkg/rpm/sonar.repo

sudo yum -y install sonar

#############################
echo "Start Postgres connection configuration"
#############################

echo "Make backup of original sonar.properties"
sudo mv /opt/sonar/conf/sonar.properties /opt/sonar/conf/sonar.properties.bkup
echo "Move sparse sonar.properties to /opt/sonar/conf"
sudo mv /tmp/postgres-config/sonar.properties /opt/sonar/conf

#############################
echo "Install Postgres client in order to create database Sonar DB in Postgres"
#############################

sudo yum install postgresql -y

#############################
echo "Install Sonar scanner..."
#############################

sudo mkdir -p /opt/sonar_scanner
sudo chown sonar /opt/sonar_scanner
cd /opt/sonar_scanner
sudo wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.2.0.1227-linux.zip
sudo unzip sonar-scanner-cli-3.2.0.1227-linux.zip

cd /opt/sonar_scanner/sonar-scanner-3.2.0.1227-linux/conf

echo 'sonar.host.url=http://localhost:9000' | sudo tee -a sonar-scanner.properties

export PATH=$PATH:/opt/sonar_scanner/sonar-scanner-3.2.0.1227-linux/bin

echo "Start sonar service..."
sudo service sonar start

echo "Check sonar status..."
sudo service sonar status

echo "Add service to start at boot"
sudo chkconfig --add sonar

END_TIMESTAMP=`date +"%Y-%m-$d %T"`
echo End time : ${END_TIMESTAMP}

