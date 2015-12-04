FROM ubuntu:wily
MAINTAINER agw.lvs.sainokuni@gmail.com
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install curl unzip
RUN apt-get -y install openjdk-8-jdk
RUN apt-get -y autoremove
RUN apt-get -y autoclean

RUN mkdir -p /opt/h2/db
WORKDIR /opt/h2
ADD h2-1.4.190.jar /opt/h2

EXPOSE 9092
CMD java -cp h2-1.4.190.jar org.h2.tools.Server -tcp -tcpAllowOthers -baseDir /opt/h2/db
