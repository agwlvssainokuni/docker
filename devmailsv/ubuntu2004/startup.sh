#!/bin/bash
# -*- coding: utf-8 -*-
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

########################################################################
# (1) SSH HOST KEY
ssh-keygen -A

########################################################################
# (2) SERVER CERTIFICATE FOR POSTFIX AND DOVECOT
if [[ ! (-f /devmailsv-cert.pem && -f /devmailsv-key.pem) ]]; then
    (cd / && /root/createcert.sh)
    # POSTFIX
    (cd /etc/ssl/certs/ && rm -f ssl-cert-snakeoil.pem && ln -s /devmailsv-cert.pem ssl-cert-snakeoil.pem)
    (cd /etc/ssl/private/ && rm -f ssl-cert-snakeoil.key && ln -s /devmailsv-key.pem ssl-cert-snakeoil.key)
    # DOVECOT
    (cd /etc/dovecot/private/ && rm -f dovecot.pem && ln -s /devmailsv-cert.pem dovecot.pem)
    (cd /etc/dovecot/private/ && rm -f dovecot.pem && ln -s /devmailsv-key.pem dovecot.pem)
fi

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
