#!/bin/bash
echo "Executing base image setup"

START_TIMESTAMP=`date +"%Y-%m-$d %T"`
echo Start time : ${START_TIMESTAMP}

echo "Update the image to the latest patches"
sudo yum update -y

echo "Remove java 1.7"
sudo yum erase java-1.7.0* -y

echo "Navigate to /opt directory"
cd /opt/

echo "Installing Open JDK 1.8.0..."
sudo yum -y install java-1.8.0-openjdk-devel

# Go back to home
cd ~

echo "Retrieve Artifactory repo information"
wget https://bintray.com/jfrog/artifactory-rpms/rpm -O bintray-jfrog-artifactory-rpms.repo

echo "Move repo information to /etc/yum.repos.d/ "
sudo mv bintray-jfrog-artifactory-rpms.repo /etc/yum.repos.d/

echo "Install Artifactory via yum"
sudo yum install jfrog-artifactory-oss -y

#################################
# Start of MySQL configuration
#################################

echo "Move jar containing JDBC driver into /opt/jfrog/artifactory/tomcat/lib"
sudo mv /tmp/mysql-config/mysql-connector-java.jar /opt/jfrog/artifactory/tomcat/lib

sudo chown root:root /opt/jfrog/artifactory/tomcat/lib/mysql-connector-java.jar

#echo "Backup /etc/opt/jfrog/artifactory/etc/db.properties to /etc/opt/jfrog/artifactory/db.properties.org"
#sudo mv /etc/opt/jfrog/artifactory/db.properties /etc/opt/jfrog/artifactory/db.properties.orig

echo "Make directory /etc/opt/jfrog/artifactory/etc"
sudo mkdir /etc/opt/jfrog/artifactory/etc

echo "Move db.properties from /tmp/mysql-config/db.properties to /etc/opt/jfrog/artifactory/etc/"
sudo mv /tmp/mysql-config/db.properties /etc/opt/jfrog/artifactory/etc/

echo "Change /etc/opt/jfrog/artifactory/etc/db.properties owner to artifactory:artifactory"
sudo chown artifactory:artifactory /etc/opt/jfrog/artifactory/etc/db.properties

#################################
echo "Install mysql client in order to create database Artifactory DB in MySQL"
#################################

sudo yum install -y mysql

#################################
# End of MySQL configuration
#################################

echo "Test the service"
sudo service artifactory check

echo "Restart the service"
sudo service artifactory restart

END_TIMESTAMP=`date +"%Y-%m-$d %T"`
echo End time : ${END_TIMESTAMP}
