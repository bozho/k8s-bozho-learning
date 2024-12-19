#!/bin/bash
# Secure SSHD
sed -i -e 's/^PermitRootLogin yes/PermitRootLogin no/' '/etc/ssh/sshd_config'
rm -f /root/.ssh/authorized_keys
systemctl restart ssh

# Mount local storage
DISK_UUID=$(blkid -s UUID -o value /dev/sdb)
mkdir -p /mnt/local-storage/$DISK_UUID
mount -t ext4 /dev/sdb /mnt/local-storage/$DISK_UUID
echo UUID=`blkid -s UUID -o value /dev/sdb` /mnt/local-storage/$DISK_UUID ext4 defaults 0 2 | tee -a /etc/fstab
