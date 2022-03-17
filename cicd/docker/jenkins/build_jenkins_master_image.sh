#!/bin/bash

docker build -f Dockerfile-jenkins-master -t williamdrew/jenkins-master:manifest-arm64v8 --build-arg ARCH=arm64v8/ .

#docker build -f Dockerfile-jenkins-master -t williamdrew/jenkins-master:manifest-amd64 --build-arg ARCH=amd64/ .
