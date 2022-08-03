FROM openjdk:8u212-alpine

LABEL name "Springboot base image" 
LABEL maintainer "Cognizant"
LABEL version=1.0

USER root

COPY build/libs/spring-boot-0.0.1-SNAPSHOT.jar $APP_LOC/app.jar

ENTRYPOINT ["java","-jar","app.jar"]