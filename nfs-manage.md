####
Verifying NFS Server from Client
####
    showmount -e your_nfs_server_ip
####
Verifying Which Port Using for NFS Server 
####
    rpcinfo -p | grep nfs
####
Verifying NFS Disk Usage
####
#du -sh /nfs-mounted-volume   
####    
    du -sh /nfs/home
####
rpcinfo -p nfs-server-ip
####
    rpcinfo -p 10.77.123.50
####


