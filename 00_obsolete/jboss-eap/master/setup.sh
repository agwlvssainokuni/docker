#!/bin/bash

function jboss-cli {
	echo $1
	/opt/jboss-eap-6.4/bin/jboss-cli.sh -c --command="$1"
}

/opt/jboss-eap-6.4/bin/domain.sh &
sleep 5

jboss-cli "/profile=ha/subsystem=datasources/jdbc-driver=my.h2:add(driver-name=my.h2,driver-module-name=my.h2,xa-datasource-class=org.h2.jdbcx.JdbcDataSource)"

jboss-cli "/server-group=main-server-group:remove()"
jboss-cli "/server-group=other-server-group:remove()"
jboss-cli "/server-group=default:add(profile=ha,socket-binding-group=ha-sockets)"

jboss-cli "reload --host=master"
sleep 5

jboss-cli "shutdown --host=master"

wait
