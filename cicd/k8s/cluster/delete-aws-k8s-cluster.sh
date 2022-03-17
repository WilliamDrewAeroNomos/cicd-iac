#!/bin/bash

#kops create secret --name ${CLUSTER_NAME} sshpublickey admin -i ~/.ssh/kops-key.pub

kops delete cluster ${CLUSTER_NAME} --yes
