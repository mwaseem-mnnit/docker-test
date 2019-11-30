FROM anapsix/alpine-java:8_jdk-dcevm
LABEL maintainer="hotswapagent.org" description="DCEVM+HotswapAgent"
RUN apk -U upgrade \
    && apk add curl \
    && apk add unzip \
    && mkdir -p /opt/hotswap-agent/ \
    && curl -L -o /opt/hotswap-agent/hotswap-agent-1.3.1-SNAPSHOT.jar "https://github.com/HotswapProjects/HotswapAgent/releases/download/1.3.1-SNAPSHOT/hotswap-agent-1.3.1-SNAPSHOT.jar" \
    && ln -f -s /opt/hotswap-agent/hotswap-agent-1.3.1-SNAPSHOT.jar /opt/hotswap-agent/hotswap-agent.jar

WORKDIR /
ADD vendor-contract-backend.jar vendor-contract-backend.jar
ADD java_command.sh java_command.sh
EXPOSE 8082
#CMD java -Xmx100m -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap  -jar  -Dserver.port=5000 -Dspring.profiles.active=local vendor-contract-backend.jar
CMD bash java_command.sh