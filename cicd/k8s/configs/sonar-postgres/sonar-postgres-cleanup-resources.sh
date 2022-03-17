#!/bin/bash

kubectl delete -f sonar-postgres-service.yaml
kubectl delete -f sonar-postgres-deployment.yaml
kubectl delete -f sonar-postgres-pvc.yaml
kubectl delete -f sonar-postgres-pv.yaml

kubectl delete -f sonar-postgres-create-secrets.yaml

