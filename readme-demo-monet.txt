:################################################################################## 
:# ! Run scripts in Windows Powershell or cmd
:#
:# This file describes steps taken to implement the scope of this project.
:#
:# This is demo application for Monet+
:#
:# Follow example: https://docs.docker.com/language/java/build-images/
:# Use example application https://github.com/spring-projects/spring-petclinic
:#
:# Scope of Work:
:# --------------
:# • Rozjet docker                                                            * Windows Docker Desktop
:# • Stáhnout image (java spring nejaká demo appka s db (oracle/postgres)     * 
:# • Nachystat nejlépe v Postman test api demo aplikace                       * App running on localhost:8080
:# • Spustit si docker-compose a v nem zprovoznit DB a demo aplikaci          * Images pushed to Docker HUB, GIT
:# • Rozjet si minishift/minukube a spustit v nem db a demo aplikaci          
:# • Optional nasadit Prometheus a Grafana pro zobrazena monitoringu systému
:# • Konfigurace uložit do gitu (gitlab,github…) 
:################################################################################## 
:# This demo is implemented on Windows platform and Docker Linux based containers 
:#
:# Required Software Setup (optionally use winget or chocolatey) 
:# -------------------------------------------------------------
:# Install Windows Subsystem for Linux (WSL), Ubuntu distro.
:# Install Java runtime from https://jdk.java.net/ https://www.oracle.com/java/technologies/downloads/#jdk20-windows
:# Install GIT from https://gitforwindows.org
:# Install Docker Desktop from https://www.docker.com/products/docker-desktop
:# Install Postman from https://www.postman.com
:# Optionally Install Tortoise GIT frontend from https://tortoisegit.org
:######################################################################################
 
:# Start Docker Desktop including Docker daemon 
start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"

:# Start Docker daemon 
:# runas.exe /savecred /user:radek "c:\Program Files\Docker\Docker\resources\dockerd.exe"

:# Clone example app GIT repository to local
git clone https://github.com/spring-projects/spring-petclinic.git
:# git clone https://github.com/spring-petclinic/spring-petclinic-rest.git
:# git clone https://github.com/dockersamples/spring-petclinic-docker

:##############################
:# TEST PETCLINIC APP LOCALLY #
:##############################
 
:# Test Run application locally 
cd spring-petclinic && .\mvnw spring-boot:run 

:# Test app in web browser http://localhost:8080
:# Terminate app

:#####################################
:# RUN APP & DB IN DOCKER CONTAINERS #
:#####################################
 
:# Pull required Docker Images from Hub to local
:# ---------------------------------------------
docker pull mysql & ^
docker pull postgres & ^
docker pull eclipse-temurin:17-jdk-jammy & ^
docker pull eclipse-temurin:17-jre-jammy

:# Check List Docker images
docker images

:# Test run Docker images
docker run --name demo-monet-db-mysql -e MYSQL_PASSWORD=mysecretpassword -d mysql
docker run --name demo-monet-db-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres

:# Stop Docker images
docker stop demo-monet-db-mysql
docker stop demo-monet-db-postgres

:# Create Dockerfile with the following content:
:# 
:# FROM eclipse-temurin:17-jdk-jammy
:# WORKDIR /app
:# COPY .mvn/ .mvn
:# COPY mvnw pom.xml ./
:# RUN ./mvnw dependency:resolve
:# COPY src ./src
:# EXPOSE 8080
:# CMD ["./mvnw", "spring-boot:run", "-Dspring-boot.run.profiles=mysql"]
:# 

:# Create a .dockerignore file with the following content: (binaries)
:# 
:# target
:# 

:# Create persistent volumes for db
docker volume create demo-monet-db_data   
docker volume create demo-monet-db_config

:# Create network for app and db
docker network create demo-monet-db-net

:# Run db Docker image Mysql
docker run -it --rm -d -v demo-monet-db_data:/var/lib/mysql ^
-v demo-monet-db_config:/etc/mysql/conf.d ^
--network demo-monet-db-net --name demo-monet-db-2 ^
-e MYSQL_USER=petclinic -e MYSQL_PASSWORD=petclinic ^
-e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=petclinic ^
-p 3306:3306 mysql

:# Build app Docker image, config file Dockerfile (MySQL) in \spring-petclinic
docker build --tag demo-monet-app-mysql .

:# Build app Docker image, config file Dockerfile_Postgress \spring-petclinic
docker build --tag demo-monet-app-postgres -f Dockerfile_Postgress .

:# Run db Docker image Postgres
docker run --rm --name demo-monet-db-postgres --network demo-monet-db-net ^
-e POSTGRES_PASSWORD=petclinic -e POSTGRES_DB=petclinic -p 5432:5432 -d postgres

:# Check Docker images
docker images

:# Run app Docker image configure for Mysql 
docker run --rm -d ^
--name demo-monet-app-mysql ^
--network demo-monet-db-net ^
-e MYSQL_URL=jdbc:mysql://demo-monet-db/petclinic ^
-p 8080:8080 demo-monet-app-mysql

:# Run app Docker image configure for Postgres  

# Run app Docker image for postgres
docker run -d --name demo-monet-app-postgres --network demo-monet-db-net ^
-e POSTGRES_URL:jdbc:postgresql://demo-monet-db/petclinic ^
-p 8888:8888 demo-monet-app-postgres

# Check running containers
docker ps

# Check status "UP" REST API locally
curl --request GET --url http://localhost:8080/actuator/health --header 'content-type: application/json'

# Check status "UP" REST API locally
curl --request GET --url http://localhost:8888/actuator/health --header 'content-type: application/json'

# Test DB request for app nad db running both standalone containers
curl  --request GET ^
      --url http://localhost:8080/vets ^
      --header 'content-type: application/json'

:############################################
:# Include PREBUILT APP to image            #
:# Multi-stage Dockerfile_MultiStage        # 
:# .\demo-monet-docker-build-multistage.cmd #
:# .\spring-petclinic\Dockerfile_MultiStage #
:############################################
:#
:# Create Dockerfile_MultiStage with the following content:
:# .\spring-petclinic\Dockerfile_MultiStage
:# 
:# FROM eclipse-temurin:17-jdk-jammy as base
:# WORKDIR /app
:# COPY .mvn/ .mvn
:# COPY mvnw pom.xml ./
:# RUN ./mvnw dependency:resolve
:# COPY src ./src
:# RUN ./mvnw package
:# COPY target ./target
:# 
:# #FROM base as development
:# #CMD ["./mvnw", "spring-boot:run", "-Dspring-boot.run.profiles=mysql", "-Dspring-boot.run.jvmArguments='-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8000'"]
:# 
:# #FROM base as build
:# #RUN ./mvnw package
:# 
:# FROM eclipse-temurin:17-jre-jammy as production
:# EXPOSE 8080
:# COPY --from=base /app/target/spring-petclinic-*.jar /spring-petclinic.jar
:# CMD ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/spring-petclinic.jar"]

:# Run script
.\demo-monet-docker-build-multistage.cmd

:#########################################
:# DOCKER COMPOSE                        #
:# .\demo-monet-docker-compose.cmd       #
:# .\spring-petclinic\docker-compose.yml #
:#########################################
:#
:# Create docker-compose.yml with the following content:
:# 
:# version: '3.8'
:# services:
:#   demo-monet-petclinic:
:#     image: demo-monet-app
:#     container_name: demo-monet-app
:#     ports:
:#       - "8000:8000"
:#     environment:
:#       - SERVER_PORT=8000
:#       - MYSQL_URL=jdbc:mysql://mysqlserver/petclinic
:#     volumes:
:#       - ./:/app
:#     depends_on:
:#       - demo-monet-mysqlserver
:# 
:#   demo-monet-petclinic-prebuilt:
:#     image: demo-monet-app-multi-stage
:#     container_name: demo-monet-app-prebuilt
:#     ports:
:#       - "8080:8080"
:#     environment:
:#       - SERVER_PORT=8080
:#       - MYSQL_URL=jdbc:mysql://mysqlserver/petclinic
:#     volumes:
:#       - ./:/app
:#     depends_on:
:#       - demo-monet-mysqlserver
:# 
:#   demo-monet-mysqlserver:
:#     image: mysql
:#     container_name: demo-monet-db
:#     ports:
:#       - "3306:3306"
:#     environment:
:#       - MYSQL_ROOT_PASSWORD=
:#       - MYSQL_ALLOW_EMPTY_PASSWORD=true
:#       - MYSQL_USER=petclinic
:#       - MYSQL_PASSWORD=petclinic
:#       - MYSQL_DATABASE=petclinic
:#     volumes:
:#       - mysql_data:/var/lib/mysql
:#       - mysql_config:/etc/mysql/conf.d
:# volumes:
:#   mysql_data:
:#   mysql_config:
:# 

:# Run docker compose
.\demo-monet-docker-compose.cmd

:###############################
:# Run containers via MINIKUBE #
:# .\demo-monet-minikube.cmd   #
:###############################

:# Run script
.\demo-monet-minikube.cmd

:##############################
:# POSTMAN                    #
:# Config file loc: .\Postman #
:##############################

:# Test API Response 
curl --request GET --url http://localhost:8080/actuator/health --header 'content-type: application/json'

:# Run script

:##############################
:# VARIOUS GIT OPERATIONS     #
:##############################

:# Run minikube script
.\demo-monet-minikube.cmd

:# Go to local repo root dir
:# git init -b main
:# git add .
:# git add -A
:# git commit -m "Baseline app +docker"
:# git tag -a -m "Baseline app +docker" v1
:# 
:# git remote add origin https://github.com/radek-pozdnicek/demo-monet-petclinic-ex
:# git push 

