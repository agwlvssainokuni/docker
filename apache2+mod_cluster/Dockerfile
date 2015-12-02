FROM ubuntu:wily
MAINTAINER agw.lvs.sainokuni@gmail.com
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install apache2 apache2-dev
RUN apt-get -y install curl unzip

RUN apt-get -y install build-essential
RUN apt-get -y install autoconf libtool

WORKDIR /var/tmp/
ADD build.sh /var/tmp/
ADD mod_cluster-1.3.1.Final-src.tar.gz /var/tmp/
ENV MOD_CLUSTER_DIR /var/tmp/mod_cluster-1.3.1.Final-src/srclib/mod_cluster
RUN bash build.sh ${MOD_CLUSTER_DIR}/native/advertise/
RUN bash build.sh ${MOD_CLUSTER_DIR}/native/mod_manager/
RUN bash build.sh ${MOD_CLUSTER_DIR}/native/mod_proxy_cluster/
RUN bash build.sh ${MOD_CLUSTER_DIR}/native/mod_cluster_slotmem/
RUN rm -f build.sh
RUN rm -rf mod_cluster-1.3.1.Final-src
WORKDIR /

RUN apt-get -y purge build-essential autoconf libtool
RUN apt-get -y autoremove
RUN apt-get -y autoclean

ADD mod_cluster.load /etc/apache2/mods-available/
ADD mod_cluster.conf /etc/apache2/mods-available/
ADD mod_cluster-manager.conf /etc/apache2/sites-available/
RUN a2enmod mod_cluster
RUN a2ensite mod_cluster-manager

#CMD service apache2 start
#CMD /bin/bash
