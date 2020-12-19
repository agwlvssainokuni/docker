FROM centos:centos8

RUN dnf install -y rsyslog openssh-server postfix dovecot mailx passwd \
    && systemctl enable rsyslog.service \
    && systemctl enable sshd.service \
    && systemctl enable postfix.service \
    && systemctl enable dovecot.service

ARG CERT_NAME=devmailsv
ARG CERT_CN=devmailsv
ARG CERT_OU=devmailsv
ARG CERT_KEYLEN=2048
ARG CERT_DAYS=3650

RUN \
# [共用TLS鍵対生成]
    openssl req -x509 -outform PEM -keyform PEM \
        -out /etc/pki/tls/certs/${CERT_NAME}.pem \
        -keyout /etc/pki/tls/private/${CERT_NAME}.pem \
        -subj "/OU=${CERT_OU}/CN=${CERT_CN}" -nodes \
        -newkey rsa:${CERT_KEYLEN} -days ${CERT_DAYS} \
# [Postfix設定]
# (1) /etc/postfix/main.cf
    && sed -i_DIST -e 's/^\(inet_interfaces = \)/## \1/' /etc/postfix/main.cf \
    && sed -i-e 's/^\(smtpd_tls_cert_file = \)/## \1/' /etc/postfix/main.cf \
    && sed -i-e 's/^\(smtpd_tls_key_file = \)/## \1/' /etc/postfix/main.cf \
    && echo >> /etc/postfix/main.cf \
    && echo "########################################" >> /etc/postfix/main.cf \
    && echo "# DEV MAIL SERVER CONFIGURATION" >> /etc/postfix/main.cf \
    && echo "# (0) BASE" \
    && echo "inet_interfaces = all" >> /etc/postfix/main.cf \
    && echo "home_mailbox = Maildir/" >> /etc/postfix/main.cf \
    && echo "# (1) NEVER DELIVER" >> /etc/postfix/main.cf \
    && echo "disable_dns_lookups = yes" >> /etc/postfix/main.cf \
    && echo "transport_maps = hash:/etc/postfix/transport" >> /etc/postfix/main.cf \
    && echo "# (2) ENABLE TLS" >> /etc/postfix/main.cf \
    && echo "smtpd_use_tls = yes" >> /etc/postfix/main.cf \
    && echo "smtpd_tls_cert_file = /etc/pki/tls/certs/${CERT_NAME}.pem" >> /etc/postfix/main.cf \
    && echo "smtpd_tls_key_file = /etc/pki/tls/private/${CERT_NAME}.pem" >> /etc/postfix/main.cf \
    && echo "# (3) ENABLE SMTP AUTH" >> /etc/postfix/main.cf \
    && echo "smtpd_sasl_auth_enable = yes" >> /etc/postfix/main.cf \
    && echo "smtpd_sasl_type = dovecot" >> /etc/postfix/main.cf \
    && echo "smtpd_sasl_path = private/auth" >> /etc/postfix/main.cf \
# (2) /etc/postfix/transport
    && echo -e "*\tlocal:" >> /etc/postfix/transport \
    && postmap /etc/postfix/transport \
# [Dovecot設定]
# (3) /etc/dovecot/conf.d/11-devmailsv.conf
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
    && echo "}" >> /etc/dovecot/conf.d/11-devmailsv.conf \
    && echo "# (3) /etc/dovecot/conf.d/10-ssl.conf" >> /etc/dovecot/conf.d/11-devmailsv.conf \
    && echo "ssl_cert = </etc/pki/tls/certs/${CERT_NAME}.pem" >> /etc/dovecot/conf.d/11-devmailsv.conf \
    && echo "ssl_key = </etc/pki/tls/private/${CERT_NAME}.pem" >> /etc/dovecot/conf.d/11-devmailsv.conf

COPY *.sh /root/

EXPOSE 22
EXPOSE 25 587 465
EXPOSE 110 995
EXPOSE 143 993

ENV TZ=Asia/Tokyo
CMD ["/sbin/init", "-D"]
