#!/bin/bash

docker build -f Dockerfile-jenkins-slave-jnlp1 -t williamdrew/jenkins-slave-jnlp1 .
docker build -f Dockerfile-jenkins-slave-jnlp2 -t williamdrew/jenkins-slave-jnlp2 .

