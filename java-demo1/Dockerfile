#FROM java:8
#COPY . /usr/src/myapp
#WORKDIR /usr/src/myapp
#ENTRYPOINT ["/bin/bash", "-c", "ls"]
#RUN javac HelloWorld.java
#CMD java - jar HelloWorld.jar
#ENTRYPOINT ["/bin/bash", "-c", "java -jar vendor-contract-backend.jar -Dserver.port=8080 -Dspring.profiles.active=local"]
#ENTRYPOINT ["java", " -jar " , "vendor-contract-backend.jar"]

FROM centos
MAINTAINER belfort <belfort@rivigo.com>

#terminal setting
#ENV TERM xterm
ENV dockerBuildVersion 1

#installing dependencies
RUN yum  -y install \
    epel-release \
    net-tools \
    java-1.8.0-openjdk-devel \
    wget
WORKDIR /
ADD vendor-contract-backend.jar vendor-contract-backend.jar
EXPOSE 8080
CMD java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005  -Xmx100m -Dserver.port=5000 -Dspring.profiles.active=local -jar vendor-contract-backend.jar
