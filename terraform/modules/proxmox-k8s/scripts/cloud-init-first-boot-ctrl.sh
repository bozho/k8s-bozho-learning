#!/bin/bash
# Secure SSHD
sed -i -e 's/^PermitRootLogin yes/PermitRootLogin no/' '/etc/ssh/sshd_config'
rm -f /root/.ssh/authorized_keys
systemctl restart ssh
