#!/bin/bash
#Install the NFS Client on the Client Systems
apt update -y
apt install nfs-common -y
systemctl start nfs-common
systemctl enable nfs-common
mkdir -p /nfs-share
chmod 777 /nfs-share
mount 192.168.0.96:/nfs-share /nfs-share
systemctl restart nfs-server.service
cd /nfs-share
ls -l
