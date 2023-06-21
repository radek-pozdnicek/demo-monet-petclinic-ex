:#####################################################################
:# Demo-Monet-petclinic to start docker compose of app and database  #
:# as specified in config .\spring-petclinic\docker-compose.yml      #
:#####################################################################

:# Start Docker Desktop including Docker daemon 
start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"

:# Start Docker daemon 
:# runas.exe /savecred /user:radek "c:\Program Files\Docker\Docker\resources\dockerd.exe"

:# Login to Docker
:# docker login -u "pozdnicek" --password-stdin docker.io

:# Optionally pull the image from Docker Hub without building it
:# docker pull mysql & ^
:# docker pull postgres & ^
:# docker pull pozdnicek/demo-monet-app:latest & ^
:# docker pull pozdnicek/demo-monet-app-multi-stage:latest

:# Docker Compose down
docker compose down
docker compose stop

:# Docker Compose app and db
cd .\spring-petclinic
docker compose up
:# docker compose up -f .\spring-petclinic\docker-compose.yml

:# Press any key to close
timeout /t -1