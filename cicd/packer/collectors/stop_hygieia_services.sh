#!/bin/bash

echo "Sonar collector status "
sudo service sonar_collector stop
echo "Jenkins collector status "
sudo service jenkins_collector stop
echo "GitlLab collector status "
sudo service gitlab_collector stop
echo "Score collector status "
sudo service score_collector stop
echo "Hygieia API collector status "
sudo service hygieia_api stop
echo "Hygieia UI collector status "
sudo service hygieia_ui stop


 
