:#####################################################################
:# Demo-Monet-petclinic to start app in local minikube               #
:#####################################################################

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
kubectl run demo-monet-app-multi-stage --image=pozdnicek/demo-monet-app-multi-stage:latest --port=8080 

:#kubectl expose demo-monet-app-multi-stage --type=LoadBalancer --port=8080
kubectl expose deployment petclinic --type=LoadBalancer --port 8080 --target-port 8080

minikube service demo-monet-app-multi-stage

:# ?? kubectl port-forward service/demo-monet-app-multi-stage 7080:8080

:# List Kubernetes Pods:
kubectl get pods

:# Now, we can check whether the deployment was successful:
kubectl get deployments

kubectl get services

:# Show events:
kubectl get events

:# Open dashboard
minikube dashboard

:# Cleanup
kubectl delete service demo-monet-app-multi-stage
kubectl delete deployment demo-monet-app-multi-stage
minikube stop
minikube delete

:# Press any key to close
timeout /t -1










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
kubectl run demo-monet-app-multi-stage --image=pozdnicek/demo-monet-app-multi-stage:latest --port=8080 

kubectl expose demo-monet-app-multi-stage --type=LoadBalancer --port=8080

minikube service demo-monet-app-multi-stage

:# List Kubernetes Pods:
kubectl get pods

:# Now, we can check whether the deployment was successful:
kubectl get deployments

kubectl get services

:# Show events:
kubectl get events

:# Open dashboard
minikube dashboard

:# Cleanup
kubectl delete service demo-monet-app-multi-stage
kubectl delete deployment demo-monet-app-multi-stage
minikube stop
minikube delete

:# Press any key to close
timeout /t -1