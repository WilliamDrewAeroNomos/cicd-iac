#!/bin/bash
echo "Executing Dashboard base image setup"

START_TIMESTAMP=`date +"%Y-%m-$d %T"`
echo Start time : ${START_TIMESTAMP}

echo "Update the image to the latest patches"
sudo yum update -y

echo "Update the image to the latest patches"
sudo yum install epel-release -y
sudo yum update -y

echo "Remove java 1.7..."
sudo yum erase java-1.7.0* -y

echo "Install Java 1.8.0..."
sudo yum install java-1.8.0-openjdk.x86_64 -y

sudo cp /etc/profile /etc/profile_backup
echo 'export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk' | sudo tee -a /etc/profile
echo 'export JRE_HOME=/usr/lib/jvm/jre' | sudo tee -a /etc/profile
source /etc/profile

echo $JAVA_HOME
echo $JRE_HOME

echo "Install JDK..."

sudo yum install java-1.8.0-openjdk-devel -y

echo "Install Maven..."

wget http://mirror.olnevhost.net/pub/apache/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz
tar xvf apache-maven-3.5.4-bin.tar.gz
sudo mv apache-maven-3.5.4 /usr/local/apache-maven

echo 'export M2_HOME=/usr/local/apache-maven' | sudo tee -a ~/.bashrc
echo 'export M2=$M2_HOME/bin' | sudo tee -a ~/.bashrc
echo 'export PATH=$M2:$PATH' | sudo tee -a ~/.bashrc
source ~/.bashrc

echo "Install git..."

sudo yum install git -y

cd ~

echo "Build Hygieia and all components..."

mkdir hygieia-jars

echo "Build core"
git clone -b v3.5.2 --single-branch https://github.com/Hygieia/hygieia-core.git
cd hygieia-core
mvn clean install package
cp target/core-3.5.2-SNAPSHOT.jar ~/hygieia-jars/
cd ~

echo "Clone down main source tree"
git clone -b v3.1.0 --single-branch https://github.com/Hygieia/Hygieia.git

echo "Build UI"
cd Hygieia/UI
npm install
cd ~

echo "Build API"
git clone -b v3.1.3 --single-branch https://github.com/Hygieia/api.git
cd api
mvn clean install package
cp target/api.jar ~/hygieia-jars/
cd ~

echo "Build Hygieia"
cd Hygieia
mvn clean install package

echo "Build the Sonar collector"

git clone -b v3.1.2 --single-branch https://github.com/Hygieia/hygieia-codequality-sonar-collector.git
cd hygieia-codequality-sonar-collector/
mvn clean install package
cp target/sonar-codequality-collector.jar ~/hygieia-jars/
cd ~

echo "Build Jenkins publisher"

git clone https://github.com/Hygieia/hygieia-publisher-jenkins-plugin.git
cd hygieia-publisher-jenkins-plugin/
mvn clean install package
cp target/hygieia-publisher.jar ~/hygieia-jars/
cd ~

echo "Build Jenkins collector"

git clone -b v3.1.1 --single-branch https://github.com/Hygieia/hygieia-build-jenkins-collector.git
cd hygieia-build-jenkins-collector/
mvn clean install package
cp target/jenkins-build-collector-3.1.1-SNAPSHOT.jar ~/hygieia-jars/
cd ~

echo "Build GitHub collector"

git clone -b v3.1.3 --single-branch https://github.com/Hygieia/hygieia-scm-github-collector.git
cd hygieia-scm-github-collector/
mvn clean install package
cp target/github-scm-collector.jar ~/hygieia-jars/
cd ~

echo "Build GitLab collector"

git clone --single-branch https://github.com/Hygieia/hygieia-scm-gitlab-collector.git
cd hygieia-scm-gitlab-collector/
mvn clean install package
cp target/gitlab-scm-collector.jar ~/hygieia-jars/
cd ~

echo "Build Score collector"

git clone --single-branch https://github.com/Hygieia/hygieia-misc-score-collector.git
cd hygieia-misc-score-collector/
mvn clean install package
cp target/score-collector.jar ~/hygieia-jars/
cd ~

echo "Create symbolic link for hygieia collector jars"

cd ~/hygieia-jars
sudo ln -s core-3.5.2-SNAPSHOT.jar core.jar
sudo ln -s jenkins-build-collector-3.1.1-SNAPSHOT.jar jenkins-build-collector.jar

cd ~

echo "Configure package manangement system"

echo '[mongodb-org-4.0]' | sudo tee -a /etc/yum.repos.d/mongodb-org-4.0.repo
echo 'name=MongoDB Repository' | sudo tee -a /etc/yum.repos.d/mongodb-org-4.0.repo
echo 'baseurl=https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/4.0/x86_64/' | sudo tee -a /etc/yum.repos.d/mongodb-org-4.0.repo
echo 'gpgcheck=1' | sudo tee -a /etc/yum.repos.d/mongodb-org-4.0.repo
echo 'enabled=1' | sudo tee -a /etc/yum.repos.d/mongodb-org-4.0.repo
echo 'gpgkey=https://www.mongodb.org/static/pgp/server-4.0.asc' | sudo tee -a /etc/yum.repos.d/mongodb-org-4.0.repo

echo "Install mongodb and configure as a service at startup"

sudo yum install -y mongodb-org

sudo service mongod start

sudo service mongod status

sudo chkconfig mongod on

# Move collector scripts, api properties and mongo config files to /etc/init.d
sudo cp /tmp/collectors/* /etc/init.d/

# Create user and dashboard database

mongo < /etc/init.d/mongosrc.js

# Install nodejs

curl --silent --location https://rpm.nodesource.com/setup_10.x | sudo bash -
sudo yum -y install gcc-c++ make
sudo yum -y install nodejs

# Install npm
curl -sL https://rpm.nodesource.com/setup_6.x | sudo -E bash -

# Install bower
sudo npm install bower -g

# Install gulp
sudo npm install gulp -g

echo "Installing the collectors..."

cd /etc/init.d

# Sonar
sudo service sonar_collector start
sudo service sonar_collector status
sudo chkconfig sonar_collector on

# Artifactory
#sudo service artifactory_collector start
#sudo service artifactory_collector status
#sudo chkconfig artifactory_collector on

# GitLab
sudo service gitlab start
sudo service gitlab_collector status
sudo chkconfig gitlab_collector on

# Jenkins
sudo service jenkins_collector start
sudo service jenkins_collector status
sudo chkconfig jenkins_collector on

# API
sudo service hygieia_api start
sudo service hygieia_api status
sudo chkconfig hygieia_api on

# UI
sudo service hygieia_ui start
sudo service hygieia_ui status
sudo chkconfig hygieia_ui on

END_TIMESTAMP=`date +"%Y-%m-$d %T"`
echo End time : ${END_TIMESTAMP}

