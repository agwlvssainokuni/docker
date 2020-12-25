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
#   /usr/lib/systemd/system/sshd-keygen.target
#    => sshd-keygen@rsa.service
#    => sshd-keygen@ecdsa.service
#    => sshd-keygen@ed25519.service
#       /usr/lib/systemd/system/sshd-keygen@.service
type=rsa
[[ ! -f /etc/ssh/ssh_host_${type}_key ]] && /usr/libexec/openssh/sshd-keygen ${type}
type=ecdsa
[[ ! -f /etc/ssh/ssh_host_${type}_key ]] && /usr/libexec/openssh/sshd-keygen ${type}
type=ed25519
[[ ! -f /etc/ssh/ssh_host_${type}_key ]] && /usr/libexec/openssh/sshd-keygen ${type}

########################################################################
# (2) SERVER CERTIFICATE FOR POSTFIX AND DOVECOT
if [[ ! (-f /devmailsv-cert.pem && -f /devmailsv-key.pem) ]]; then
    (cd / && /root/createcert.sh)
    # POSTFIX
    (cd /etc/pki/tls/certs/ && rm -f postfix.pem && ln -s /devmailsv-cert.pem postfix.pem)
    (cd /etc/pki/tls/private/ && rm -f postfix.key && ln -s /devmailsv-key.pem postfix.key)
    # DOVECOT
    (cd /etc/pki/dovecot/certs/ && rm -f dovecot.pem && ln -s /devmailsv-cert.pem dovecot.pem)
    (cd /etc/pki/dovecot/private/ && rm -f dovecot.pem && ln -s /devmailsv-key.pem dovecot.pem)
fi

exec /usr/bin/supervisord -c /etc/supervisord.conf
