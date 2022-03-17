#!/bin/bash
echo "Executing base image setup"

START_TIMESTAMP=`date +"%Y-%m-$d %T"`
echo Start time : ${START_TIMESTAMP}

echo "Update the image to the latest patches"
sudo yum install epel-release -y
sudo yum update -y

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash

. ~/.nvm/nvm.sh

nvm install node

node -e "console.log('Running Node.js ' + process.version)"

END_TIMESTAMP=`date +"%Y-%m-$d %T"`
echo End time : ${END_TIMESTAMP}
