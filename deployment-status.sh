#!/bin/bash
if ! kubectl get ns sarina-joshi; then
    kubectl create ns sarina-joshi
fi

if ! kubectl rollout status deployment sample-spring-boot -n sarina-joshi; then
    kubectl apply -f kubernetes.yml
fi