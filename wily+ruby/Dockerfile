FROM ubuntu:wily
MAINTAINER agw.lvs.sainokuni@gmail.com
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install curl unzip
RUN apt-get -y autoremove
RUN apt-get -y autoclean
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN /usr/local/rvm/bin/rvm get head
RUN /usr/local/rvm/bin/rvm install ruby
RUN /usr/local/rvm/bin/rvm alias create default ruby
COPY gem-wrapper.sh /
RUN bash /gem-wrapper.sh install bundler
RUN rm -f /gem-wrapper.sh
