#!/bin/bash

echo "Start Sonar collector "
sudo service sonar_collector start
echo "Start Jenkins collector"
sudo service jenkins_collector start
echo "Start GitlLab collector "
sudo service gitlab_collector start
echo "Start Score collector "
sudo service score_collector start
echo "Start Hygieia API collector "
sudo service hygieia_api start
echo "Start Hygieia UI collector "
sudo service hygieia_ui start
 
