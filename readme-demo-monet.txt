So far implented *** and not implemented xxx
Scope of Work:
--------------
• Rozjet docker *** Windows Docker Desktop
• Stáhnout image (java spring nejaká demo appka s db (oracle/postgres) *** Petclinic example
• Nachystat nejlépe v Postman test api demo aplikace xxx App running on localhost:8080
• Spustit si docker-compose a v nem zprovoznit DB a demo aplikaci *** Images pushed to Docker HUB, GIT
• Rozjet si minishift/minukube a spustit v nem db a demo aplikaci xxx
• Optional nasadit Prometheus a Grafana pro zobrazena monitoringu systému xxx
• Konfigurace uložit do gitu (gitlab,github…) *** For the implemented parts

# ! Run scripts in Windows Powershell or cmd
#
# This file describes steps taken to implement the scope of this project.
#
# This is demo application for Monet+
#
# Follow example: https://docs.docker.com/language/java/build-images/
# Use application https://github.com/spring-projects/spring-petclinic
#
#
# Scope of Work:
# --------------
# • Rozjet docker                                                            * Windows Docker Desktop
# • Stáhnout image (java spring nejaká demo appka s db (oracle/postgres)     * 
# • Nachystat nejlépe v Postman test api demo aplikace                       * App running on localhost:8080
# • Spustit si docker-compose a v nem zprovoznit DB a demo aplikaci          * Images pushed to Docker HUB, GIT
# • Rozjet si minishift/minukube a spustit v nem db a demo aplikaci          
# • Optional nasadit Prometheus a Grafana pro zobrazena monitoringu systému
# • Konfigurace uložit do gitu (gitlab,github…) 
 
# This demo is implemented on Windows platform and Docker Linux based containers 

# Required Software Setup (optionally use winget or chocolatey) 
# -------------------------------------------------------------
# Install Windows Subsystem for Linux (WSL), Ubuntu distro.
# Install Java runtime from https://jdk.java.net/ https://www.oracle.com/java/technologies/downloads/#jdk20-windows
# Install GIT from https://gitforwindows.org
# Install Docker Desktop from https://www.docker.com/products/docker-desktop
# Install Postman from https://www.postman.com
# Optionally Install Tortoise GIT frontend from https://tortoisegit.org
 
# Start Docker as desktop app

# Clone example app GIT repository to local
git clone https://github.com/spring-projects/spring-petclinic.git
# git clone https://github.com/spring-petclinic/spring-petclinic-rest.git
# git clone https://github.com/dockersamples/spring-petclinic-docker
 
# Test Run application locally 
cd spring-petclinic && .\mvnw spring-boot:run 

# Test app in web browser
http://localhost:8080

# Terminate app
 
######################################
# DOCKER EXERCISE STARTS HERE - SKIP #
######################################
 
# Parts below are Docker exercise up to docker compose
 
# Pull required Docker Images from Hub to local
# ---------------------------------------------
docker pull mysql & ^
docker pull postgres & ^
docker pull eclipse-temurin:17-jdk-jammy & ^
docker pull eclipse-temurin:17-jre-jammy

# Check List Docker images
docker images

# Build Docker Image with app

# Test run Docker images
docker run --name demo-monet-db-mysql -e POSTGRES_PASSWORD=mysecretpassword -d mysql
docker run --name demo-monet-db-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres

# Stop Docker images
docker stop demo-monet-db-mysql
docker stop demo-monet-db-postgres

# Create Dockerfile with the following content:
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency:resolve
COPY src ./src
EXPOSE 8080
CMD ["./mvnw", "spring-boot:run", "-Dspring-boot.run.profiles=mysql"]

# Create a .dockerignore file with the following content: (exclude binaries)
target

# Create persistent volumes for db
docker volume create demo-monet-db_data   
docker volume create demo-monet-db_config

docker volume create demo-monet-mysql_data   
docker volume create demo-monet-mysql_config

# Create network for app and db
docker network create demo-monet-db-net

# Run db Docker image Mysql
docker run -it --rm -d -v demo-monet-db_data:/var/lib/mysql ^
-v demo-monet-db_config:/etc/mysql/conf.d ^
--network demo-monet-db-net --name demo-monet-db ^
-e MYSQL_USER=petclinic -e MYSQL_PASSWORD=petclinic ^
-e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=petclinic ^
-p 3306:3306 mysql

# Build app Docker image 
# CMD ["./mvnw", "spring-boot:run", "-Dspring-boot.run.profiles=postgres"]
docker build --tag demo-monet-app-postgres -f Dockerfile_Postgress .

# Build app Docker image 
# CMD ["./mvnw", "spring-boot:run", "-Dspring-boot.run.profiles=mysql"]
docker build --tag demo-monet-app .

# Run db Docker image Postgres
docker run --rm --name demo-monet-db-postgres --network demo-monet-db-net ^
-e POSTGRES_PASSWORD=petclinic -e POSTGRES_DB=petclinic -p 5432:5432 -d postgres

# Check Docker images
docker images

# Run app Docker image with mysql 
docker run --rm -d ^
--name demo-monet-app ^
--network demo-monet-db-net ^
-e MYSQL_URL=jdbc:mysql://demo-monet-db/petclinic ^
-p 8080:8080 demo-monet-app

#OR

# Run app Docker image with postgres
docker run -d --name demo-monet-app-postgres --network demo-monet-db-net ^
-e POSTGRES_URL:jdbc:postgresql://demo-monet-db/petclinic ^
-p 8888:8888 demo-monet-app

# Check running containers
docker ps

# Check status "UP" REST API locally
curl --request GET --url http://localhost:8080/actuator/health --header 'content-type: application/json'

# Test DB request for app nad db running both standalone containers
curl  --request GET ^
      --url http://localhost:8080/vets ^
      --header 'content-type: application/json'

# Multi-stage Dockerfile for development

# Create Dockerfile_MultiStage with the following content:

FROM eclipse-temurin:17-jdk-jammy as base
WORKDIR /app
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency:resolve
COPY src ./src

RUN ./mvnw package
COPY target ./target
#COPY *.* ./  

#FROM base as development
#CMD ["./mvnw", "spring-boot:run", "-Dspring-boot.run.profiles=mysql", "-Dspring-boot.run.jvmArguments='-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8000'"]

#FROM base as build
#RUN ./mvnw package

FROM eclipse-temurin:17-jre-jammy as production
EXPOSE 8080
COPY --from=base /app/target/spring-petclinic-*.jar /spring-petclinic.jar
CMD ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/spring-petclinic.jar"]

# Build Multi Stage image
docker build --tag demo-monet-app-multi-stage -f Dockerfile_MultiStage .

#############################
# DOCKER EXERCISE ENDS HERE #
#############################

##############################
# DOCKER COMPOSE STARTS HERE #
##############################

# Create docker-compose.dev.yml with the following content:

version: '3.8'
services:
  demo-monet-petclinic:
    image: demo-monet-app
    container_name: demo-monet-app
    ports:
      - "8000:8000"
    environment:
      - SERVER_PORT=8000
      - MYSQL_URL=jdbc:mysql://mysqlserver/petclinic
    volumes:
      - ./:/app
    depends_on:
      - demo-monet-mysqlserver

  demo-monet-petclinic-prebuilt:
    image: demo-monet-app-multi-stage
    container_name: demo-monet-app-prebuilt
    ports:
      - "8080:8080"
    environment:
      - SERVER_PORT=8080
      - MYSQL_URL=jdbc:mysql://mysqlserver/petclinic
    volumes:
      - ./:/app
    depends_on:
      - demo-monet-mysqlserver

  demo-monet-mysqlserver:
    image: mysql
    container_name: demo-monet-db
    ports:
      - "3306:3306"
    environment:
      - MYSQL_ROOT_PASSWORD=
      - MYSQL_ALLOW_EMPTY_PASSWORD=true
      - MYSQL_USER=petclinic
      - MYSQL_PASSWORD=petclinic
      - MYSQL_DATABASE=petclinic
    volumes:
      - mysql_data:/var/lib/mysql
      - mysql_config:/etc/mysql/conf.d
volumes:
  mysql_data:
  mysql_config:

# DOWN Docker Compose frontend app and backend db
docker compose down
docker compose stop
docker compose kill

docker-compose -f docker-compose.dev.yml up -d

# Use the provided docker-compose.yml file to start the database containers
docker-compose --profile mysql up
docker-compose --profile postgres up

docker compose up -d
docker compose down

Docker Compose is a tool for running multi-container applications on Docker, 
which are defined using the compose YAML file. 
You can start your applications with a single command: docker-compose up.

# Or build Docker Image
# .\mvnw spring-boot:build-image

# Login to Docker
docker login -u "pozdnicek" --password-stdin docker.io
".5h8jAgCR3W@K6x" 

# Tag images to push built images to Docker Hub
docker tag demo-monet-app pozdnicek/demo-monet-app:latest & ^
docker tag demo-monet-app-multi-stage pozdnicek/demo-monet-app-multi-stage:latest

# Push images to Docker Hub
docker push pozdnicek/demo-monet-app:latest & ^
docker push pozdnicek/demo-monet-app-multi-stage:latest

# Optionally pull the image from Docker Hub without building it
docker pull pozdnicek/demo-monet-app:latest & ^
docker pull pozdnicek/demo-monet-app-multi-stage:latest

# Go to local repo root dir

git remote add origin https://github.com/radek-pozdnicek/demo-monet-petclinic

# Push to Git Hub
git add *.*

git commit -m "Baseline app +docker"
git tag -a -m "Baseline app +docker" v1
git push --follow-tags

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



