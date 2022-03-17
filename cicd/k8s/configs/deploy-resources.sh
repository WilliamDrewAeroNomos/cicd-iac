#!/bin/bash

cd sonar-postgres
./sonar-postgres-deploy-resources.sh
#cd ../artifactory
#./artifactory-deploy-resources.sh
#cd ../gitlab
#./gitlab-deploy-resources.sh
#cd ../jenkins
#./jenkins-deploy-resources.sh
cd ../sonarqube
./sonarqube-deploy-resources.sh

