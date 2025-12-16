# 📚 NFS Server Troubleshooting & Hardening Guide  
**From Setup to Security – A Complete DevOps-Friendly Reference**  

> ✅ **For**: Linux Admins, DevOps Engineers, Cloud Practitioners  
> 🌐 **Environment**: Ubuntu/Debian-based NFS Server (e.g., `192.168.0.35`)  
> 🛠️ **Goal**: Fix common issues, secure exports, and automate NFS reliably  

---

## 🔍 Table of Contents
1. [Common Symptoms & Initial Checks](#-common-symptoms--initial-checks)  
2. [Understanding Your NFS Server Status](#-understanding-your-nfs-server-status)  
3. [Fixing `showmount -e`: RPC Errors](#-fixing-showmount--e-rpc-errors)  
4. [Secure & Correct `/etc/exports` Configuration](#-secure--correct-etcexports-configuration)  
5. [IP Change Impact & Recovery](#-ip-change-impact--recovery)  
6. [Security Hardening Best Practices](#-security-hardening-best-practices)  
7. [Firewall & Port Requirements](#-firewall--port-requirements)  
8. [NFSv4 vs NFSv3: Recommendation](#-nfsv4-vs-nfsv3-recommendation)  
9. [Automation: Scripting & Ansible](#-automation-scripting--ansible)  
10. [Troubleshooting Masked Services](#-troubleshooting-masked-services)  
11. [Final Validation Checklist](#-final-validation-checklist)  

---

## 🚨 Common Symptoms & Initial Checks

| Symptom | Likely Cause |
|--------|--------------|
| `showmount -e` → `clnt_create: RPC: Unable to receive` | Firewall blocking, `rpcbind`/`nfs-server` not running, or client missing `nfs-common` |
| Client can’t mount share | Incorrect `/etc/exports`, permission issues, or IP/subnet mismatch |
| `mount: wrong fs type` | NFS client tools not installed (`nfs-common`) |
| Service won’t start | Service masked or config syntax error |

👉 **First, run on server**:
```bash
ip a                          # Confirm current IP (e.g., 192.168.0.35)
systemctl status nfs-kernel-server
systemctl status nfs-common
showmount -e localhost        # Should list exports
```

---

## 🧩 Understanding Your NFS Server Status

From your output:
```bash
inet 192.168.0.35/24 ... enp1s0   # ✅ Server IP confirmed
systemctl status nfs-common       # ✅ Running (but needs daemon-reload warning ignored)
showmount -e                      # ❌ Failed (RPC error → client-side issue)
```

> 💡 `showmount -e` **without IP** tries localhost. If it fails, check `rpcbind`:
> ```bash
> sudo systemctl restart rpcbind nfs-kernel-server
> ```

---

## 🔧 Fixing `showmount -e`: RPC Errors

### On **Client Machine**:
```bash
# Install NFS client tools
sudo apt install nfs-common -y

# Test from client
showmount -e 192.168.0.35
```

### On **Server**:
Ensure these services are **active**:
```bash
sudo systemctl enable --now rpcbind nfs-kernel-server
sudo systemctl restart nfs-kernel-server
```

> ⚠️ If you see `Warning: unit file changed on disk`, run:
> ```bash
> sudo systemctl daemon-reload
> ```

---

## 📁 Secure & Correct `/etc/exports` Configuration

### ❌ **Your Current Risky Config**:
```bash
/nfs-share *(rw,...,no_root_squash)   # ⚠️ OPEN TO INTERNET!
/nfs-share/kubernetes *(rw,...)       # ⚠️ Same!
```

### ✅ **Secure & Recommended Config**:
```bash
# /etc/exports — copy-paste ready
/nfs-share                            192.168.0.0/24(rw,sync,root_squash,no_subtree_check)
/nfs-share/kubernetes                 192.168.0.0/24(rw,sync,root_squash,no_subtree_check)
/nfs-share/openstack                  192.168.0.0/24(rw,sync,root_squash,no_subtree_check)
/nfs-share/docker/wordpress-data      192.168.0.0/24(rw,sync,root_squash,no_subtree_check)
/nfs-share/docker/wordpress-data/mysql 192.168.0.0/24(rw,sync,root_squash,no_subtree_check)
```

### Apply Changes:
```bash
sudo exportfs -rav
sudo systemctl reload nfs-kernel-server
```

> 🔐 **Never use `*` in production** — always restrict to your LAN (`192.168.0.0/24`).

---

## 🔄 IP Change Impact & Recovery

You changed IP from `192.168.0.96` → `192.168.0.35`.

### What to Do:
1. **Update `/etc/exports`** — ensure client ranges match your LAN (you did this ✅).
2. **Reload exports** — done via `exportfs -ra`.
3. **Notify clients** — they must remount using new IP (or use DNS/DHCP reservation).

> 💡 **Pro Tip**: Use static DHCP lease for NFS server to avoid future IP changes.

---

## 🛡️ Security Hardening Best Practices

| Risk | Fix |
|------|-----|
| `no_root_squash` | Replace with `root_squash` (default) unless **absolutely required** |
| Wildcard `*` | Replace with `192.168.0.0/24` |
| Unnecessary `insecure` | Remove unless legacy client fails |
| World-writable shares | Set proper directory ownership: `chown nobody:nogroup /nfs-share` |
| Exposing to WAN | Ensure firewall blocks port 2049 from public internet |

> ✅ **WordPress/MySQL does NOT need `no_root_squash`** — container runs as non-root user.

---

## 🔥 Firewall & Port Requirements

### For **NFSv4** (Recommended):
```bash
sudo ufw allow from 192.168.0.0/24 to any port 2049 proto tcp
```

### For **NFSv3** (Legacy, avoid if possible):
```bash
sudo ufw allow from 192.168.0.0/24 to any port 111 proto tcp
sudo ufw allow from 192.168.0.0/24 to any port 111 proto udp
sudo ufw allow from 192.168.0.0/24 to any port 2049 proto tcp
# + dynamic ports (not recommended)
```

> 🌟 **Use NFSv4** → only **port 2049/tcp** needed → simpler & more secure.

---

## 📡 NFSv4 vs NFSv3: Recommendation

| Feature | NFSv3 | NFSv4 |
|--------|-------|-------|
| Ports | Many (111, 2049 + dynamic) | Only **2049/tcp** |
| Security | Weak | Supports Kerberos (optional) |
| Firewall | Complex | Simple |
| Stateful | No | Yes (better recovery) |

### ✅ **Enable NFSv4** (usually default on modern systems).  
No extra config needed — just mount with:
```bash
mount -t nfs4 192.168.0.35:/kubernetes /mnt
```

> Note: In NFSv4, `/nfs-share` becomes the **virtual root**. Exports appear as subdirs.

---

## 🤖 Automation: Scripting & Ansible

### Directory Setup Script:
```bash
#!/bin/bash
SHARE="/nfs-share"
mkdir -p $SHARE/{kubernetes,openstack,docker/wordpress-data/mysql}
chown -R nobody:nogroup $SHARE
chmod -R 755 $SHARE
```

### Minimal Ansible Snippet:
```yaml
- name: Configure secure NFS exports
  copy:
    dest: /etc/exports
    content: |
      /nfs-share 192.168.0.0/24(rw,sync,root_squash,no_subtree_check)
      /nfs-share/kubernetes 192.168.0.0/24(rw,sync,root_squash,no_subtree_check)
  notify: reload nfs

- name: Ensure services running
  systemd:
    name: "{{ item }}"
    enabled: yes
    state: started
  loop:
    - rpcbind
    - nfs-kernel-server

handlers:
  - name: reload nfs
    command: exportfs -ra
```

> 💡 Store `/etc/exports` in Git for version control.

---

## ⚙️ Troubleshooting Masked Services

If you see:
```bash
Failed to start nfs-server: Unit nfs-server.service is masked.
```

### Fix:
```bash
# Unmask the service
sudo systemctl unmask nfs-server

# Reload systemd
sudo systemctl daemon-reload

# Start it
sudo systemctl start nfs-server
```

> 🔍 Check masking status:
> ```bash
> systemctl is-enabled nfs-server  # Output: "masked" or "disabled"
> ```

---

## ✅ Final Validation Checklist

Run these on **server** and **client**:

| Check | Command |
|------|--------|
| ✅ Server IP correct? | `ip a` |
| ✅ Services running? | `systemctl is-active nfs-kernel-server rpcbind` |
| ✅ Exports loaded? | `exportfs -v` |
| ✅ Local test OK? | `showmount -e localhost` |
| ✅ Remote test OK? | From client: `showmount -e 192.168.0.35` |
| ✅ Mount works? | `mount -t nfs4 192.168.0.35:/kubernetes /mnt` |
| ✅ Firewall OK? | `ufw status` (should allow 2049 from LAN) |
| ✅ No `*` or `no_root_squash`? | `grep -v "^#" /etc/exports` |

---

## 📌 Conclusion

Your NFS server is now:
- ✅ **Functional** after IP change  
- ✅ **Secure** (no open exports, no root squashing)  
- ✅ **Maintainable** (structured exports, automation-ready)  
- ✅ **Troubleshootable** (clear validation steps)

> 🔗 **Next Steps**:  
> - Set up **static IP via DHCP reservation**  
> - Consider **NFS over TLS** for future (experimental)  
> - Use **NFS Subdir External Provisioner** for Kubernetes PVs

---

**Author**: Sumon (DevOps & Cloud Engineer)  
**Last Updated**: December 16, 2025  
**License**: MIT — Feel free to use, share, and improve!  

> 💬 **Feedback?** Found a missing case? Open an issue or PR!  

--- 
