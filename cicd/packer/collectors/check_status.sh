#!/bin/bash

echo "Sonar collector status "
service sonar_collector status
echo "Jenkins collector status "
service jenkins_collector status
echo "GitlLab collector status "
service gitlab_collector status
echo "Score collector status "
service score_collector status
echo "Hygieia API collector status "
service hygieia_api status
echo "Hygieia UI collector status "
service hygieia_ui status
 
