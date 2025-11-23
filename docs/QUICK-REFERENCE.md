# CrocLinux Quick Reference Card

## 🚀 5-Minute Quick Start

### Option 1: VM Image (Easiest!)
```
1. Download: CrocLinux-v1.0.0.ova from GitHub Releases
2. VirtualBox: File → Import Appliance → Select OVA → Import
3. Start VM → Login: analyst / Croc!2025
4. Done! Start using tools
```

### Option 2: ISO Installation
```
1. Download: CrocLinux-full-YYYYMMDD.iso from GitHub Releases
2. Create bootable USB (Rufus/Balena Etcher)
3. Boot from USB → Install CrocLinux
4. Login: analyst / Croc!2025
```

---

## 📋 Essential Commands

### First Boot
```bash
passwd                    # Change password (CRITICAL!)
sudo apt update           # Update package list
sudo apt upgrade -y       # Upgrade system
crocsec status            # Check service status
```

### Service Management
```bash
sudo systemctl start wazuh-manager elasticsearch kibana
sudo systemctl status wazuh-manager
sudo systemctl restart wazuh-manager
```

### CrocSec CLI
```bash
crocsec summary           # Get overview
crocsec status            # Check services
crocsec update_rules      # Update rules
```

### Rule Updates
```bash
sudo croc-update-rules    # Update Sigma & YARA rules
```

### Theme Switch
```bash
sudo /opt/croc/scripts/base/configure_theme.sh hacker  # Green on black
sudo /opt/croc/scripts/base/configure_theme.sh dark     # Dark with blue
```

---

## 🌐 Web Interfaces

| Service | URL | Default Login |
|---------|-----|--------------|
| **Kibana** | https://127.0.0.1:5601 | `elastic` / `CHANGEME` |
| **Wazuh** | https://127.0.0.1:5601/app/wazuh | `wazuh` / `CHANGE_ME` |
| **MISP** | https://127.0.0.1 | `admin@croc.local` / `Croc!2025` |
| **TheHive** | http://127.0.0.1:9000 | Create on first login |
| **Cortex** | http://127.0.0.1:9001 | Create on first login |
| **Velociraptor** | https://127.0.0.1:8000 | Generated on first start |

---

## 🔑 Default Credentials

| Service | Username | Password | Action Required |
|---------|----------|----------|-----------------|
| **System** | `analyst` | `Croc!2025` | ⚠️ Change immediately! |
| **Kibana** | `elastic` | `CHANGEME` | ⚠️ Change immediately! |
| **Wazuh** | `wazuh` | `CHANGE_ME` | ⚠️ Change immediately! |
| **MISP** | `admin@croc.local` | `Croc!2025` | ⚠️ Change immediately! |

---

## 📁 Important Directories

```bash
/opt/croc/scripts/              # CrocLinux scripts
/var/ossec/                      # Wazuh configuration
/var/www/MISP/                  # MISP data
/etc/thehive/                   # TheHive configuration
/var/log/                       # System logs
/var/ossec/logs/                # Wazuh logs
```

---

## 🛠️ Tool Access

### Via Menu
```
Applications → Blue Team → [Category] → [Tool]
```

### Via Terminal
```bash
# Open terminal: Ctrl+Alt+T
# Use tool commands directly
```

### Via Desktop
```
Click desktop shortcuts for quick access
```

---

## 🔧 Common Tasks

### Update Detection Rules
```bash
sudo croc-update-rules
sudo systemctl restart wazuh-manager
```

### Import Threat Indicators
```bash
sudo croc-ioc-import /path/to/ioc.json
```

### Check Service Logs
```bash
sudo journalctl -u wazuh-manager -f
sudo journalctl -u elasticsearch -f
sudo tail -f /var/ossec/logs/alerts/alerts.json
```

### Monitor System
```bash
htop                    # System resources
df -h                   # Disk usage
sudo netstat -tulpn     # Network connections
```

---

## 🆘 Troubleshooting

### Services Won't Start
```bash
sudo systemctl status <service>
sudo journalctl -u <service> -f
sudo systemctl restart <service>
```

### Web Interface Not Accessible
```bash
sudo systemctl status kibana wazuh-manager
sudo ufw status
sudo netstat -tulpn | grep 5601
```

### Theme Not Applying
```bash
sudo /opt/croc/scripts/base/configure_theme.sh hacker
xfce4-panel -r
# Logout and login again
```

---

## 📊 Service Ports

| Service | Port | Protocol |
|---------|------|----------|
| **Kibana** | 5601 | HTTPS |
| **Elasticsearch** | 9200 | HTTPS |
| **Wazuh API** | 55000 | HTTPS |
| **Wazuh Syslog** | 1514 | UDP |
| **MISP** | 443 | HTTPS |
| **TheHive** | 9000 | HTTP |
| **Cortex** | 9001 | HTTP |
| **Velociraptor** | 8000 | HTTPS |

---

## ✅ Verification Checklist

### After Installation
- [ ] Login successful
- [ ] Password changed
- [ ] System updated
- [ ] Services running
- [ ] Web interfaces accessible
- [ ] Tools accessible via menu

### After Configuration
- [ ] Wazuh configured
- [ ] MISP configured
- [ ] TheHive configured
- [ ] Rules updated
- [ ] Dashboards working

---

## 📚 Documentation Links

- **Step-by-Step Guide**: [Complete Instructions](STEP-BY-STEP-GUIDE.md)
- **Download Guide**: [How to Download](download-guide.md)
- **Usage Guide**: [How to Use Tools](usage-guide.md)
- **Theme Guide**: [Customize Theme](theme-guide.md)
- **Complete Guide**: [Full Reference](complete-guide.md)

---

**CrocLinux — The Silent Guardian of Cyber Defense** 🐊

**Need Help?** See [Step-by-Step Guide](STEP-BY-STEP-GUIDE.md) for detailed instructions

