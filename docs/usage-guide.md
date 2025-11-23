# CrocLinux Usage Guide

## Overview
This guide explains how to use CrocLinux after installation - accessing tools, configuring services, and using the CrocSec CLI assistant.

## Quick Start

### 1. Login
- **Username**: `analyst`
- **Password**: `Croc!2025`
- **Change Password**: `passwd` (run immediately)

### 2. Access Tools
- **Menu**: Click **Applications** → **Blue Team** menu
- **CLI**: Open terminal and type `crocsec status`
- **Desktop**: Click desktop shortcuts for quick access

### 3. Start Services
```bash
# Check service status
sudo systemctl status wazuh-manager elasticsearch kibana

# Start services if needed
sudo systemctl start wazuh-manager elasticsearch kibana
```

## Menu Structure

### Blue Team Menu
All tools are organized in the **Blue Team** menu:

#### SIEM & Dashboards
- **Kibana (CrocSec Dashboard)**: Main SOC dashboard
- **Wazuh SIEM Console**: Security events console
- **Suricata Alerts Dashboard**: Network IDS alerts

#### Threat Intelligence
- **MISP Threat Platform**: Threat intelligence sharing
- **YARA Rules**: Malware detection rules
- **Sigma Rules**: Detection rules

#### Incident Response
- **TheHive Incident Console**: Case management
- **Cortex Analyzers**: Automated analysis
- **Velociraptor Console**: Endpoint response
- **GRR Rapid Response**: Remote response

#### Endpoint Forensics
- **Autopsy Digital Forensics**: Disk forensics
- **Volatility3**: Memory forensics
- **OSQuery Shell**: Endpoint querying

#### Automation & Scripting
- **CrocSec Assistant**: CLI helper
- **Update Sigma & YARA Rules**: Rule updates
- **IOC Import**: Threat indicator import

## Web Interfaces

### Kibana Dashboard
- **URL**: https://127.0.0.1:5601
- **Default Login**: `elastic` / `CHANGEME`
- **Features**: SOC dashboards, Wazuh alerts, Suricata events

### Wazuh Console
- **URL**: https://127.0.0.1:5601/app/wazuh
- **Features**: Security events, agent management, rules

### MISP Platform
- **URL**: https://127.0.0.1
- **Default Login**: `admin@croc.local` / `Croc!2025`
- **Features**: Threat intelligence sharing, IOC management

### TheHive
- **URL**: http://127.0.0.1:9000
- **Features**: Case management, incident tracking
- **Setup**: Create admin account on first login

### Cortex
- **URL**: http://127.0.0.1:9001
- **Features**: Automated analysis, analyzers
- **Setup**: Create admin account on first login

### Velociraptor
- **URL**: https://127.0.0.1:8000
- **Features**: Endpoint response, hunting
- **Setup**: Generate credentials on first start

## CrocSec CLI Assistant

### Available Commands
```bash
# Get summary
crocsec summary

# Check service status
crocsec status

# Update rules
crocsec update_rules

# Investigate alerts
crocsec investigate
```

### Using CrocSec
```bash
# Open CrocSec assistant
crocsec summary

# Check all services
crocsec status

# Update detection rules
sudo croc-update-rules

# Import IOCs
sudo croc-ioc-import /path/to/ioc.json
```

## Common Tasks

### Update Detection Rules
```bash
# Update Sigma and YARA rules
sudo croc-update-rules

# Verify rules updated
sudo systemctl status wazuh-manager
```

### Import Threat Indicators
```bash
# Import IOCs into MISP
sudo croc-ioc-import /path/to/ioc.json

# Verify import
curl -k -u admin@croc.local:Croc!2025 https://127.0.0.1/events/index
```

### Configure Wazuh Agents
```bash
# Install agent on remote host
wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.8.0-1_amd64.deb
sudo dpkg -i wazuh-agent_4.8.0-1_amd64.deb

# Configure agent
sudo nano /var/ossec/etc/ossec.conf

# Start agent
sudo systemctl start wazuh-agent
```

### Configure Suricata
```bash
# Edit Suricata config
sudo nano /etc/suricata/suricata.yaml

# Restart Suricata
sudo systemctl restart suricata

# Check logs
sudo tail -f /var/log/suricata/eve.json
```

### Access Elasticsearch
```bash
# Check Elasticsearch status
curl -k -u elastic:CHANGEME https://127.0.0.1:9200

# View indices
curl -k -u elastic:CHANGEME https://127.0.0.1:9200/_cat/indices
```

## Service Management

### Start All Services
```bash
sudo systemctl start wazuh-manager elasticsearch kibana filebeat
sudo systemctl start misp-workers thehive cortex suricata
```

### Stop All Services
```bash
sudo systemctl stop wazuh-manager elasticsearch kibana filebeat
sudo systemctl stop misp-workers thehive cortex suricata
```

### Check Service Status
```bash
sudo systemctl status wazuh-manager elasticsearch kibana
sudo systemctl status misp-workers thehive cortex suricata
```

### Enable Services on Boot
```bash
sudo systemctl enable wazuh-manager elasticsearch kibana
sudo systemctl enable misp-workers thehive cortex suricata
```

## Log Files

### Wazuh Logs
```bash
# Alerts log
sudo tail -f /var/ossec/logs/alerts/alerts.json

# Wazuh log
sudo tail -f /var/ossec/logs/ossec.log
```

### Elasticsearch Logs
```bash
# Elasticsearch log
sudo journalctl -u elasticsearch -f
```

### Suricata Logs
```bash
# Suricata events
sudo tail -f /var/log/suricata/eve.json

# Suricata log
sudo tail -f /var/log/suricata/suricata.log
```

### System Logs
```bash
# System log
sudo journalctl -f

# Auth log
sudo tail -f /var/log/auth.log
```

## Troubleshooting

### Services Won't Start
```bash
# Check service status
sudo systemctl status <service-name>

# Check logs
sudo journalctl -u <service-name> -f

# Restart service
sudo systemctl restart <service-name>
```

### Web Interfaces Not Accessible
```bash
# Check if services are running
sudo systemctl status kibana wazuh-manager misp-workers

# Check firewall
sudo ufw status

# Check ports
sudo netstat -tulpn | grep -E '5601|9200|55000'
```

### Rules Not Updating
```bash
# Check rule update script
sudo croc-update-rules

# Verify rules directory
ls -la /var/ossec/ruleset/

# Restart Wazuh
sudo systemctl restart wazuh-manager
```

## Best Practices

### Security
- Change all default passwords immediately
- Enable firewall rules
- Keep system updated
- Monitor logs regularly

### Performance
- Allocate enough RAM (8+ GB)
- Use SSD for better performance
- Monitor disk space
- Optimize Elasticsearch settings

### Maintenance
- Update rules regularly
- Backup configurations
- Monitor service logs
- Keep system updated

## Next Steps

1. **Change Passwords**: Change all default passwords
2. **Configure Services**: Configure Wazuh, MISP, TheHive
3. **Import Rules**: Update detection rules
4. **Enroll Agents**: Install Wazuh agents on endpoints
5. **Monitor**: Set up monitoring and alerts

---

**CrocLinux — The Silent Guardian of Cyber Defense** 🐊

