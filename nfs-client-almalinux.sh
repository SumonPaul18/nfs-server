#!/bin/bash
#Configure NFS Client
dnf -y install nfs-utils
showmount -e 192.168.0.96
mount -t nfs -o vers=3 192.168.0.96:/nfs-share /mnt
ls -l /mnt
cp /etc/fstab /etc/fstab.copy
cat <<EOF | sudo tee -a /etc/fstab
192.168.0.96:/nfs-share  nfs  defaults  0  0
EOF
mount -a
df -h
systemctl start rpcbind
systemctl enable rpcbind
#umount /mnt
