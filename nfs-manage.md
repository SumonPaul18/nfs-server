#
## Managing NFS Storage
Verifying NFS Server Status From <b>NFS Server</b>
####
    systemctl status nfs-kernel-server
####
Verifying NFS Client Status From <b>NFS Client</b>
####
    systemctl status nfs-common
####
Restart nfs-kernel-server From <b>NFS Server</b>
####
    systemctl restart nfs-kernel-server
####
Apply NFS Share Entry in fstab From <b>NFS Server</b>
####
    exportfs -a
####
Restart fstab After Entry From <b>NFS Server</b>
####
    exportfs -a
####
Verifying NFS Share Available
####
    showmount -e
####    
Verifying NFS Server From <b>NFS Server</b>
####
    showmount -e 192.168.0.96
####
Mount NFS to Client From <b>NFS Client</b>
####
    mount 192.168.0.96:/nfs-share /nfs-share
####
Mount NFS Share Automatically After Reboot
####
    cp /etc/fstab /etc/fstab.copy
    cat <<EOF | sudo tee -a /etc/fstab
    192.168.0.96:/nfs-share /nfs-share  nfs      defaults    0       0
    EOF
####
Unmount NFS share From <b>NFS Client</b>
####
    umount 192.168.0.96:/nfs-share /nfs-share
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
