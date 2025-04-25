## Installation and Configuration NFS Server on Ubuntu 22.04.x: 
---
### Run on NFS Server Host
#### 
    git clone https://github.com/SumonPaul18/nfs-server.git
    chmod +x -R nfs-server/nfs-server-ubuntu.sh
    . nfs-server/nfs-server-ubuntu.sh
#### 

**Note:**  After run, your default share directory is `/nfs-share`
#### Verifying the share directory
```
cd /nfs-share
ls -la
```
---
## How to Connect with NFS Server to NFS Client on Ubuntu 22.04.x: 
### Run on NFS Client Host
#### 
    git clone https://github.com/SumonPaul18/nfs-server.git
    chmod +x -R nfs-server/nfs-client-ubuntu.sh
    . nfs-server/nfs-client-ubuntu.sh
#### 

**Note:**  After run, your default share directory is `/nfs-share`

#### Verifying the share directory

```
cd /nfs-share
ls -la
```
---
