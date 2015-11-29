FROM ubuntu:wily
MAINTAINER agw.lvs.sainokuni@gmail.com
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install curl unzip
RUN apt-get -y install openjdk-8-jdk
RUN apt-get -y autoremove
RUN apt-get -y autoclean
ADD jboss-eap-6.4.0.zip /
RUN unzip -o -d /opt jboss-eap-6.4.0.zip
RUN rm -f /jboss-eap-6.4.0.zip
RUN apt-get -y install expect
ADD add-user.expect /
RUN expect /add-user.expect
RUN rm -f /add-user.expect
RUN apt-get -y purge expect
RUN apt-get -y autoremove
RUN cp -p /opt/jboss-eap-6.4/domain/configuration/host-master.xml /opt/jboss-eap-6.4/domain/configuration/host.xml
ADD setup.sh /
RUN bash /setup.sh
RUN rm -f /setup.sh
CMD /opt/jboss-eap-6.4/bin/domain.sh -b 0.0.0.0 -bmanagement 0.0.0.0
