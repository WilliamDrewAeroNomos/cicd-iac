#!/bin/bash

minikube start --memory 16384 --cpus=4 --kubernetes-version=v1.17.5

#istioctl profile dump demo > raw_demo_profile.yaml

#istioctl manifest generate -f ./raw_demo_profile.yaml --set values.global.jwtPolicy=first-party-jwt > istio-configuration.yaml

#kubectl create ns istio-system

#kubectl label namespace istio-system istio-operator-managed=Reconcile

#kubectl label namespace istio-system istio-injection=disabled

#kubectl apply -f istio-configuration.yaml

istioctl install --set profile=demo 
