#!bin/bash
#Install NFS Server and Client on Ubuntu
apt update -y
apt install nfs-kernel-server -y
systemctl start nfs-kernel-server
systemctl enable nfs-kernel-server
mkdir -p /nfs-share
chown -R nobody:nogroup /nfs-share
chmod 777 /nfs-share
cat <<EOF | sudo tee /etc/exports
/nfs-share 192.168.0.0/24(rw,sync,no_subtree_check)
EOF
exportfs -a
systemctl restart nfs-kernel-server
