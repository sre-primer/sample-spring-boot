#!/bin/bash
if ! kubectl get ns matthew-oberlies; then
    kubectl create ns matthew-oberlies
fi

if ! kubectl rollout status deployment sample-spring-boot -n matthew-oberlies; then
    kubectl apply -f kubernetes.yml
fi

if ! git diff HEAD~1 HEAD --exit-code -s kubernetes.yml; then
    echo "Changes to kubernetes.yml"
    kubectl apply -f kubernetes.yml
fi