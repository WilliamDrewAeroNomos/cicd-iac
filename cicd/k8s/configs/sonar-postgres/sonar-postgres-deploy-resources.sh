#!/bin/bash

kubectl apply -f sonar-postgres-create-secrets.yaml
kubectl apply -f sonar-postgres-pv.yaml
kubectl apply -f sonar-postgres-pvc.yaml
kubectl apply -f sonar-postgres-deployment.yaml
kubectl apply -f sonar-postgres-service.yaml

