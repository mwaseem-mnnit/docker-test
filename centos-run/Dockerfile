#FROM 906474297797.dkr.ecr.ap-southeast-1.amazonaws.com/belfort-invoicing:new3
FROM centos

MAINTAINER waseem <mwaseem.mnnit@gmail.com>

#terminal setting
#ENV TERM xterm
ENV dockerBuildVersion 1

#installing dependencies
RUN yum  -y install \
    epel-release \
    net-tools \
    wget

#RUN yum  -y install \
#    jq



#ENTRYPOINT ["/usr/bin/sh", "-c"]
#CMD ["tail", "-F", "/var/log/app-fb.log"]

#ENTRYPOINT ["/usr/bin/python"]
CMD tail -f /dev/null