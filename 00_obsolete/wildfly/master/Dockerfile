FROM ubuntu:wily
MAINTAINER agw.lvs.sainokuni@gmail.com
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install curl unzip
RUN apt-get -y install openjdk-8-jdk
RUN apt-get -y autoremove
RUN apt-get -y autoclean
ADD wildfly-9.0.2.Final.zip /
RUN unzip -o -d /opt wildfly-9.0.2.Final.zip
RUN rm -f /wildfly-9.0.2.Final.zip
RUN apt-get -y install expect
ADD add-user.expect /
RUN expect /add-user.expect
RUN rm -f /add-user.expect
RUN apt-get -y purge expect
RUN apt-get -y autoremove
RUN cp -p /opt/wildfly-9.0.2.Final/domain/configuration/host-master.xml /opt/wildfly-9.0.2.Final/domain/configuration/host.xml
ADD setup.sh /
RUN bash /setup.sh
RUN rm -f /setup.sh

EXPOSE 9999
CMD /opt/wildfly-9.0.2.Final/bin/domain.sh -b 0.0.0.0 -bmanagement 0.0.0.0
