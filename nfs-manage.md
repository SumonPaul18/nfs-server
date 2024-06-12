#
## Managing NFS Storage

Verifying NFS Server from Client:
####
    showmount -e 192.168.0.96
####
Verifying Which Port Using for NFS Server: 
####
    rpcinfo -p | grep nfs
####
Verifying NFS Disk Usage: <br>
Ex: du -sh /nfs-mounted-volume   
####    
    du -sh /nfs-share
####
Verifying NFS Using Ports:
####
    rpcinfo -p 192.168.0.96
####
Error: Unmask a Masked Service in Systemd
####
    sudo systemctl status nfs-common
####
    sudo systemctl is-enabled nfs-common
    sudo rm /lib/systemd/system/nfs-common.service
    sudo systemctl daemon-reload
    sudo systemctl enable nfs-common
    sudo systemctl start nfs-common
    sudo systemctl status nfs-common
####
