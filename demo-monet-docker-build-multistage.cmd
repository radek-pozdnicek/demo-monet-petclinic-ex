:#####################################################################
:# Demo-Monet-petclinic to start docker compose of app and database  #
:# as specified in config .\spring-petclinic\Dockerfile_MultiStage   #
:# Include prebuilt app to speed up container power up               #
:#####################################################################

:# Pull required Docker Images from Hub to local
:# ---------------------------------------------
docker pull mysql & ^
docker pull postgres & ^
docker pull eclipse-temurin:17-jdk-jammy & ^
docker pull eclipse-temurin:17-jre-jammy

:# Build Multi Stage image
cd .\spring-petclinic
docker build --tag demo-monet-app-multi-stage-nove -f Dockerfile_MultiStage .

:# Create alias to image built to push to Docker Hub.
docker tag demo-monet-app-multi-stage pozdnicek/demo-monet-app-multi-stage:latest

:# Login to Docker
docker login -u "pozdnicek" --password ".5h8jAgCR3W@K6x"  docker.io

:# Push built image to my Docker IO hub
docker push pozdnicek/demo-monet-app-multi-stage:latest

:# Press any key to close
timeout /t -1