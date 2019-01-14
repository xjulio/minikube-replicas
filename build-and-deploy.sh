#!/bin/bash

DIR=$(pwd)
NS=a2

minikube status > /dev/null 2>&1

if [ $? -ne 0 ]; then
	minikube start
fi

# Change docker context to connect docker client to minikube docker server
eval $(minikube docker-env)

cd $DIR/docker
#Build Tomcat custom image
docker image build -t tomcat:8.5-a2 . -f tomcat.Dockerfile

#Build apache custom image
docker image build -t apache:a2 . -f apache.Dockerfile

# Create namespace
kubectl describe namespace $NS > /dev/null 2>&1
if [ $? -ne 0 ]; then
	kubectl create namespace $NS
fi

cd $DIR
# create tomcat deployment and service
kubectl apply -f services/tomcat.yml

# create nginx deployment and service
kubectl apply -f services/apache.yml