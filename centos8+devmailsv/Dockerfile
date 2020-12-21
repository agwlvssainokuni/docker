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

FROM centos:centos8

RUN dnf install -y rsyslog openssh-server postfix dovecot mailx passwd \
    && systemctl enable rsyslog.service \
    && systemctl enable sshd.service \
    && systemctl enable postfix.service \
    && systemctl enable dovecot.service

RUN \
# [Postfix設定]
# (1) /etc/postfix/main.cf
    sed -i_DIST \
        -e 's/^\(inet_interfaces = \)/## \1/' \
        /etc/postfix/main.cf \
    && echo >> /etc/postfix/main.cf \
    && echo "########################################" >> /etc/postfix/main.cf \
    && echo "# DEV MAIL SERVER CONFIGURATION" >> /etc/postfix/main.cf \
    && echo "# (0) BASE" >> /etc/postfix/main.cf \
    && echo "inet_interfaces = all" >> /etc/postfix/main.cf \
    && echo "home_mailbox = Maildir/" >> /etc/postfix/main.cf \
    && echo "# (1) RELAY CONTROL" >> /etc/postfix/main.cf \
    && echo "mynetworks = 0.0.0.0/0" >> /etc/postfix/main.cf \
    && echo "# (2) NEVER DELIVER" >> /etc/postfix/main.cf \
    && echo "disable_dns_lookups = yes" >> /etc/postfix/main.cf \
    && echo "transport_maps = hash:/etc/postfix/transport" >> /etc/postfix/main.cf \
    && echo "# (3) ENABLE TLS" >> /etc/postfix/main.cf \
    && echo "smtpd_use_tls = yes" >> /etc/postfix/main.cf \
    && echo "# (4) ENABLE SMTP AUTH" >> /etc/postfix/main.cf \
    && echo "smtpd_sasl_auth_enable = yes" >> /etc/postfix/main.cf \
    && echo "smtpd_sasl_type = dovecot" >> /etc/postfix/main.cf \
    && echo "smtpd_sasl_path = private/auth" >> /etc/postfix/main.cf \
# (2) /etc/postfix/transport
    && echo -e "*\tlocal:" >> /etc/postfix/transport \
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

COPY *.sh /root/

EXPOSE 22 25 465 587 993 995

CMD ["/sbin/init", "-D"]
