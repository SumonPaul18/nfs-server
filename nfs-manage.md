#
## Managing NFS Storage
Verifying NFS Server Status
####
    systemctl status nfs-kernel-server
####
Verifying NFS Client Status
####
    systemctl status nfs-common
####
Restart nfs-kernel-server
####
    systemctl restart nfs-kernel-server
####
Verifying NFS Share Entry From <b>NFS Server</b>
####
    exportfs -a
####
Verifying NFS Share Available
####
    showmount -e
####    
Verifying NFS Server from Client:
####
    showmount -e 192.168.0.96
####
Mount NFS to Client
####
    mount 192.168.0.96:/nfs-share /nfs-share
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
<b>Error:</b> Unmask a Masked Service in Systemd
####
    sudo systemctl status nfs-common
####
<b><i>Solution:</b></i>
####
    sudo systemctl is-enabled nfs-common
    sudo rm /lib/systemd/system/nfs-common.service
    sudo systemctl daemon-reload
    sudo systemctl enable nfs-common
    sudo systemctl start nfs-common
    sudo systemctl status nfs-common
####
