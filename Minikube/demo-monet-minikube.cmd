:##################################
:# MINIKUBE (local Kubernetes)
:##################################
:# Kubernetes is an open source container orchestration platform to manage containers

:# Kubernetes is also part of Docker Desktop once enabled

:# Run in elevated Powershell
:# powershell Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

:# Install via via winget/UI
winget install minikube

:# Or https://minikube.sigs.k8s.io/docs/start/

:# Docker should be started

:# Delete existing cluster
:# minikube delete

:# Start using HyperV
minikube start --driver=hyperv --memory 2048 --cpus 2 

:# Get the cluster status:
minikube status

:# List Kubernetes Nodes:
kubectl get nodes

:# List Kubernetes Pods:
kubectl get pods

:# kubectl get services

:# Show events:
kubectl get events

:# Get info
kubectl cluster-info

:# Open dashboard
minikube dashboard

:# Run Docker container prebuilt app
kubectl run demo-monet-app-multi-stage-6 --image=pozdnicek/demo-monet-app-multi-stage:latest --port=8080 

:# Open dashboard
minikube dashboard

:# Show events:
kubectl get events

:# Now, we can check whether the deployment was successful:
kubectl get deployments

:# Press any key to close
timeout /t -1
