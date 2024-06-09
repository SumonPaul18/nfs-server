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


