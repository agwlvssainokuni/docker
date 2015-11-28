FROM ubuntu:wily
MAINTAINER agw.lvs.sainokuni@gmail.com
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install curl unzip
RUN apt-get -y install openjdk-8-jdk
RUN apt-get -y autoremove
RUN apt-get -y autoclean
COPY jboss-eap-6.4.0.zip /
RUN unzip -o -d /opt jboss-eap-6.4.0.zip
RUN rm -f /jboss-eap-6.4.0.zip
COPY h2-1.4.190.jar /
RUN /opt/jboss-eap-6.4/bin/jboss-cli.sh --command="module add --name=my.h2 --resources=/h2-1.4.190.jar --dependencies=javax.api,javax.transaction.api"
RUN rm -f /h2-1.4.190.jar
COPY host-slave.xml /opt/jboss-eap-6.4/domain/configuration/host.xml
CMD /opt/jboss-eap-6.4/bin/domain.sh -b 0.0.0.0 -bmanagement 0.0.0.0 -Djboss.domain.master.address=172.17.0.1
