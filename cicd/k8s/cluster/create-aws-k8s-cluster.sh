#!/bin/bash

#if [ "$#" -eq 1 ]; then
#  echo "Cluster name parameter required."
#  exit 1
#fi

echo "Creating cluster $CLUSTER_NAME in region $REGION with $NODE_COUNT $NODE_SIZE nodes and $MASTER_SIZE master node in DNS zone $DNS_ZONE using state store $KOPS_STATE_STORE."
read -p "Do you want to continue? " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

aws s3api create-bucket --bucket ${KOPS_BUCKET_NAME} --region ${REGION} --create-bucket-configuration LocationConstraint=${REGION}
aws s3api put-bucket-versioning --bucket ${KOPS_BUCKET_NAME} --versioning-configuration Status=Enabled
aws s3api put-bucket-encryption --bucket ${KOPS_BUCKET_NAME} --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'

kops create cluster --name=${CLUSTER_NAME} --dns-zone=${DNS_ZONE} --zones=${ZONES} --node-count=${NODE_COUNT} --master-size=${MASTER_SIZE} --node-size=${NODE_SIZE} 
 
kops create secret --name ${CLUSTER_NAME} sshpublickey admin -i ~/.ssh/kops-key.pub

kops update cluster ${CLUSTER_NAME} --yes

