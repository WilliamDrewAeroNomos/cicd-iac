#!/bin/bash
kubectl apply -f jenkins-pv.yaml
kubectl apply -f jenkins-pvc.yaml
kubectl apply -f jenkins-master-deployment.yaml
kubectl apply -f jenkins-service.yaml

