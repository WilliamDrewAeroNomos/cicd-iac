#!/bin/bash
echo "Executing gitlab base image setup"

START_TIMESTAMP=`date +"%Y-%m-$d %T"`
echo Start time : ${START_TIMESTAMP}

echo "Update the image to the latest patches"
sudo yum update -y

echo "Install necessary dependencies"
sudo yum install curl policycoreutils-python openssh-server -y

echo "Install Postfix"
sudo yum install postfix -y
sudo systemctl start postfix
sudo systemctl enable postfix
sudo systemctl status postfix

echo "Add GitLab repository and install package"
sudo curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash

END_TIMESTAMP=`date +"%Y-%m-$d %T"`
echo End time : ${END_TIMESTAMP}
