#!/bin/bash
kubectl delete -f jenkins-service.yaml
kubectl delete -f jenkins-master-deployment.yaml
kubectl delete -f jenkins-pvc.yaml
kubectl delete -f jenkins-pv.yaml

