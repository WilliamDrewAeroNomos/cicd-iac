#!/bin/bash

export CLUSTER_NAME=k8s-dev.gov-cio.com

export KOPS_BUCKET_NAME=${CLUSTER_NAME}

export KOPS_STATE_STORE=s3://${KOPS_BUCKET_NAME}

export DNS_ZONE=gov-cio.com

export NODE_SIZE=t2.medium

export MASTER_SIZE=t2.medium

export NODE_COUNT=3

export REGION=us-west-2 # Oregon, USA

export ZONES=us-west-2a

