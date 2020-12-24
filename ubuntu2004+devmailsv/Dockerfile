#
#  Copyright 2020 agwlvssainokuni
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

FROM ubuntu:20.04

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        tzdata supervisor rsyslog openssh-server \
        postfix dovecot-imapd dovecot-pop3d mailutils \
    && systemctl disable supervisor.service \
    && systemctl disable rsyslog.service \
    && systemctl disable ssh.service \
    && systemctl disable postfix.service \
    && systemctl disable dovecot.service

RUN mkdir /run/sshd \
    && echo "[supervisord]" >> /etc/supervisor/conf.d/00-base.conf \
    && echo "nodaemon=true" >> /etc/supervisor/conf.d/00-base.conf \
    && echo "[program:rsyslogd]" >> /etc/supervisor/conf.d/10-devmailsv.conf \
    && echo "command=/usr/sbin/rsyslogd -n -iNONE" >> /etc/supervisor/conf.d/10-devmailsv.conf \
    && echo "[program:sshd]" >> /etc/supervisor/conf.d/10-devmailsv.conf \
    && echo "command=/usr/sbin/sshd -D" >> /etc/supervisor/conf.d/10-devmailsv.conf \
    && echo "[program:postfix]" >> /etc/supervisor/conf.d/10-devmailsv.conf \
    && echo "command=/usr/sbin/postfix start-fg" >> /etc/supervisor/conf.d/10-devmailsv.conf \
    && echo "[program:dovecot]" >> /etc/supervisor/conf.d/10-devmailsv.conf \
    && echo "command=/usr/sbin/dovecot -F" >> /etc/supervisor/conf.d/10-devmailsv.conf

RUN \
# [Postfix設定]
# (1) /etc/postfix/main.cf
    sed -i_DIST \
        -e 's/^\(mynetworks = \)/## \1/' \
        /etc/postfix/main.cf \
    && echo >> /etc/postfix/main.cf \
    && echo "########################################" >> /etc/postfix/main.cf \
    && echo "# DEV MAIL SERVER CONFIGURATION" >> /etc/postfix/main.cf \
    && echo "# (0) BASE" >> /etc/postfix/main.cf \
    && echo "home_mailbox = Maildir/" >> /etc/postfix/main.cf \
    && echo "# (1) ALLOW RELAY" >> /etc/postfix/main.cf \
    && echo "mynetworks = 0.0.0.0/0" >> /etc/postfix/main.cf \
    && echo "# (2) FORCE LOCAL DELIVERY" >> /etc/postfix/main.cf \
    && echo "transport_maps = hash:/etc/postfix/transport" >> /etc/postfix/main.cf \
    && echo "# (3) DISCARD UNKNOWN RECIPIENT" >> /etc/postfix/main.cf \
    && echo "fallback_transport = discard: UNKNOWN RECIPIENT" >> /etc/postfix/main.cf \
    && echo "# (4) ENABLE TLS" >> /etc/postfix/main.cf \
    && echo "smtpd_use_tls = yes" >> /etc/postfix/main.cf \
    && echo "# (5) ENABLE SMTP AUTH" >> /etc/postfix/main.cf \
    && echo "smtpd_sasl_auth_enable = yes" >> /etc/postfix/main.cf \
    && echo "smtpd_sasl_type = dovecot" >> /etc/postfix/main.cf \
    && echo "smtpd_sasl_path = private/auth" >> /etc/postfix/main.cf \
# (2) /etc/postfix/transport
    && echo "########################################" >> /etc/postfix/transport \
    && echo "# FORCE LOCAL DELIVERY" >> /etc/postfix/transport \
    && echo "*\tlocal:\$myhostname" >> /etc/postfix/transport \
    && postmap /etc/postfix/transport \
# (3) /etc/postfix/master.cf
    && sed -i_DIST \
        -e 's/^#\(submission \)/\1/' \
        -e 's/^#\(  -o syslog_name=postfix\/submission\)/\1/' \
        -e 's/^#\(smtps \)/\1/' \
        -e 's/^#\(  -o syslog_name=postfix\/smtps\)/\1/' \
        -e 's/^#\(  -o smtpd_tls_wrappermode=yes\)/\1/' \
        /etc/postfix/master.cf \
# [Dovecot設定]
# (4) /etc/dovecot/conf.d/11-devmailsv.conf
    && echo "########################################" >> /etc/dovecot/conf.d/11-devmailsv.conf \
    && echo "# DEV MAIL SERVER CONFIGURATION" >> /etc/dovecot/conf.d/11-devmailsv.conf \
    && echo "# (1) /etc/dovecot/conf.d/10-mail.conf" >> /etc/dovecot/conf.d/11-devmailsv.conf \
    && echo "mail_location = maildir:~/Maildir" >> /etc/dovecot/conf.d/11-devmailsv.conf \
    && echo "# (2) /etc/dovecot/conf.d/10-master.conf" >> /etc/dovecot/conf.d/11-devmailsv.conf \
    && echo "service auth {" >> /etc/dovecot/conf.d/11-devmailsv.conf \
    && echo "  unix_listener /var/spool/postfix/private/auth {" >> /etc/dovecot/conf.d/11-devmailsv.conf \
    && echo "    mode = 0666" >> /etc/dovecot/conf.d/11-devmailsv.conf \
    && echo "    user = postfix" >> /etc/dovecot/conf.d/11-devmailsv.conf \
    && echo "    group = postfix" >> /etc/dovecot/conf.d/11-devmailsv.conf \
    && echo "  }" >> /etc/dovecot/conf.d/11-devmailsv.conf \
    && echo "}" >> /etc/dovecot/conf.d/11-devmailsv.conf

COPY scripts/*.sh /root/

EXPOSE 22 25 465 587 993 995

CMD ["/usr/bin/supervisord"]
