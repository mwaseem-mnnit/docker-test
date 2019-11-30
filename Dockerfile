#FROM 906474297797.dkr.ecr.ap-southeast-1.amazonaws.com/belfort-invoicing:new3
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

RUN yum  -y install \
    jq

