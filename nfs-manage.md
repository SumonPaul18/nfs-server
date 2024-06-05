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
Explanation about the options used in the above command.

- rw: Stands for Read/Write.
- sync: Requires changes to be written to the disk before they are applied.
- No_subtree_check: Eliminates subtree checking.

####


