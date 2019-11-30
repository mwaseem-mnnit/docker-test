#FROM java:8
#COPY . /usr/src/myapp
#WORKDIR /usr/src/myapp
#ENTRYPOINT ["/bin/bash", "-c", "ls"]
#RUN javac HelloWorld.java
#CMD java - jar HelloWorld.jar
#ENTRYPOINT ["/bin/bash", "-c", "java -jar vendor-contract-backend.jar -Dserver.port=8080 -Dspring.profiles.active=local"]
#ENTRYPOINT ["java", " -jar " , "vendor-contract-backend.jar"]


FROM anapsix/alpine-java
#MAINTAINER belfort <belfort@rivigo.com>
#RUN yum  -y install \
#    epel-release \
#    net-tools \
#    wget
#
#RUN yum  -y install \
#    jq
#
#RUN wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.2.4-x86_64.rpm
#RUN rpm2cpio filebeat-6.2.4-x86_64.rpm | cpio -idmv


WORKDIR /
ADD vendor-contract-backend.jar vendor-contract-backend.jar
EXPOSE 8080
CMD java -Xmx100m -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap  -jar  -Dserver.port=5000 -Dspring.profiles.active=local vendor-contract-backend.jar
