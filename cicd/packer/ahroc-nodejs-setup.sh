#!/bin/bash
echo "Executing base image setup"

START_TIMESTAMP=`date +"%Y-%m-$d %T"`
echo Start time : ${START_TIMESTAMP}

echo "Update the image to the latest patches"
sudo yum install epel-release -y
sudo yum update -y


END_TIMESTAMP=`date +"%Y-%m-$d %T"`
echo End time : ${END_TIMESTAMP}
