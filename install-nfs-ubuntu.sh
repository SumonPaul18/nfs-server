#!bin/bash
#Install NFS Server and Client on Ubuntu
apt update -y
apt install nfs-kernel-server -y
systemctl start nfs-kernel-server
systemctl enable nfs-kernel-server
systemctl is-active --quiet nfs-kernel-server && echo nfs-kernel-server is running
mkdir -p /nfs-share
chown -R nobody:nogroup /nfs-share
chmod 777 /nfs-share
cat <<EOF | sudo tee -a /etc/exports
/nfs-share *(rw,sync,no_subtree_check,insecure,no_root_squash)
#/nfs-share 192.168.0.0/24(rw,sync,no_subtree_check,insecure,no_root_squash)
#/nfs-share 192.168.0.0/24(rw,sync,no_subtree_check,insecure,no_root_squash)
EOF
exportfs -a
showmount -e
systemctl restart nfs-kernel-server
