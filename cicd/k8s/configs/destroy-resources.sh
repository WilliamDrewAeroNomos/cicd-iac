#!/bin/bash

#cd artifactory
#./artifactory-cleanup-resources.sh
#cd ../gitlab
#./gitlab-cleanup-resources.sh
#cd ../jenkins
#./jenkins-cleanup-resources.sh
cd ../sonarqube
./sonarqube-cleanup-resources.sh
cd ../sonar-postgres
./sonar-postgres-cleanup-resources.sh

