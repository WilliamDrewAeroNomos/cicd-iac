#!/bin/bash
START_TIMESTAMP=`date +"%Y-%m-$d %T"`
echo Start time : ${START_TIMESTAMP}
packer build -var-file=variables.json gitlab-ci-image.json 
END_TIMESTAMP=`date +"%Y-%m-$d %T"`
echo End time : ${END_TIMESTAMP}
