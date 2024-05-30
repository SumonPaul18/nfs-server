#!/bin/bash
#Configure NFS Client
dnf -y install nfs-utils
showmount -e 192.168.0.96
mount -t nfs -o vers=3 192.168.0.96:/nfs-share /mnt
ls -l /mnt
cat <<EOF | sudo tee /etc/fstab
192.168.0.96:/nfs-share  nfs  defaults  0  0
mount -a
df -h
#umount /mnt
