FROM ubuntu:20.04

#    apt-get upgrade -y && \

RUN apt-get update && \
    apt install -y gettext-base && \
    apt install -y openjdk-11-jdk && \
    apt install -y wget

## SET JAVA ENV
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

## INSTALL JBOSS
RUN mkdir -p /opt/jboss

RUN wget -O /tmp/wildfly-18.0.0.Final.tar.gz https://download.jboss.org/wildfly/18.0.0.Final/wildfly-18.0.0.Final.tar.gz
RUN tar zxvf /tmp/wildfly-18.0.0.Final.tar.gz -C /opt/jboss
RUN mv /opt/jboss/wildfly-18.0.0.Final /opt/jboss/wildfly

## CLEAN JOSS
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN /opt/jboss/wildfly/bin/add-user.sh admin 123qweASD --silent
RUN /opt/jboss/wildfly/bin/add-user.sh -a ejb test --silent


COPY ./ /opt/docker/
RUN cd /opt/docker && ./setup.sh

EXPOSE 8080
EXPOSE 9990
EXPOSE 8787
