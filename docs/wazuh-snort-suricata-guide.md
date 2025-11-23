# Wazuh, Snort & Suricata Guide for CrocLinux

## Overview
CrocLinux includes three powerful security tools: **Wazuh** (SIEM), **Snort** (Network IDS), and **Suricata** (Network IDS/IPS). This guide explains how to use and configure them.

## 🛡️ Wazuh - SIEM & XDR Platform

### What is Wazuh?
Wazuh is an open-source security platform that provides SIEM, XDR, and compliance capabilities. It monitors endpoints, detects threats, and provides real-time security analytics.

### Access Wazuh
- **Web Interface**: https://127.0.0.1:5601/app/wazuh
- **CLI**: Use `croc-wazuh` command
- **Menu**: Applications → Blue Team → SIEM & Dashboards → Wazuh SIEM Console

### Management Commands
```bash
# Check status
croc-wazuh status

# Start Wazuh
croc-wazuh start

# Stop Wazuh
croc-wazuh stop

# Restart Wazuh
croc-wazuh restart

# View alerts
croc-wazuh logs

# Test configuration
croc-wazuh test
```

### Configuration Files
- **Main Config**: `/var/ossec/etc/ossec.conf`
- **Rules**: `/var/ossec/ruleset/rules/`
- **Logs**: `/var/ossec/logs/alerts/alerts.json`

### Key Features
- **Agent Management**: Deploy agents to endpoints
- **Threat Detection**: Real-time threat detection
- **Compliance**: PCI-DSS, GDPR, HIPAA compliance
- **Vulnerability Detection**: CVE scanning
- **File Integrity Monitoring**: FIM capabilities
- **Log Analysis**: Centralized log analysis

### Integration
- **Elasticsearch**: Stores events and alerts
- **Kibana**: Visualizes data and dashboards
- **MISP**: Threat intelligence integration
- **Suricata**: Network alert ingestion
- **Snort**: Network alert ingestion

## 🚨 Suricata - Network IDS/IPS

### What is Suricata?
Suricata is a high-performance Network IDS, IPS, and Network Security Monitoring engine. It provides real-time intrusion detection and prevention.

### Access Suricata
- **CLI**: Use `croc-suricata` command
- **Menu**: Applications → Blue Team → Network Monitoring → Suricata IDS Manager
- **Dashboard**: https://127.0.0.1:5601 (Kibana)

### Management Commands
```bash
# Check status
croc-suricata status

# Start Suricata
croc-suricata start

# Stop Suricata
croc-suricata stop

# Restart Suricata
croc-suricata restart

# Reload rules (without restart)
croc-suricata reload

# View alerts
croc-suricata logs

# Update rules
croc-suricata update-rules

# Test configuration
croc-suricata test-config
```

### Configuration Files
- **Main Config**: `/etc/suricata/suricata.yaml`
- **Rules**: `/etc/suricata/rules/`
- **Local Rules**: `/etc/suricata/rules/local.rules`
- **Logs**: `/var/log/suricata/eve.json`

### Key Features
- **Real-time Detection**: Network intrusion detection
- **IPS Mode**: Intrusion prevention capabilities
- **Protocol Analysis**: Deep packet inspection
- **EVE JSON Logs**: Structured logging
- **Multi-threading**: High-performance processing
- **Rule Updates**: Automatic rule updates

### Network Interface Configuration
```bash
# Edit Suricata config
sudo nano /etc/suricata/suricata.yaml

# Change interface (default: eth0)
# Update: af-packet -> interface: <your-interface>

# Restart Suricata
croc-suricata restart
```

### Viewing Alerts
```bash
# View all alerts
sudo tail -f /var/log/suricata/eve.json | jq 'select(.event_type=="alert")'

# View specific alert types
sudo tail -f /var/log/suricata/eve.json | jq 'select(.alert.severity==1)'

# View HTTP alerts
sudo tail -f /var/log/suricata/eve.json | jq 'select(.event_type=="http")'
```

## 🔍 Snort - Network IDS

### What is Snort?
Snort is a lightweight network intrusion detection system that performs real-time traffic analysis and packet logging.

### Access Snort
- **CLI**: Use `croc-snort` command
- **Menu**: Applications → Blue Team → Network Monitoring → Snort IDS Manager

### Management Commands
```bash
# Check status
croc-snort status

# Start Snort
croc-snort start

# Stop Snort
croc-snort stop

# Restart Snort
croc-snort restart

# View alerts
croc-snort logs

# Test configuration
croc-snort test-config

# Update rules
croc-snort update-rules
```

### Configuration Files
- **Main Config**: `/etc/snort/snort.conf`
- **Rules**: `/etc/snort/rules/`
- **Local Rules**: `/etc/snort/rules/local.rules`
- **Logs**: `/var/log/snort/alert`

### Key Features
- **Real-time Detection**: Network intrusion detection
- **Packet Logging**: Full packet capture
- **Rule-based Detection**: Flexible rule system
- **Protocol Analysis**: Deep packet inspection
- **Alert Generation**: Real-time alerts

### Network Interface Configuration
```bash
# Edit Snort config
sudo nano /etc/snort/snort.conf

# Change interface (default: auto-detected)
# Update: config interface: <your-interface>

# Restart Snort
croc-snort restart
```

### Viewing Alerts
```bash
# View alerts
sudo tail -f /var/log/snort/alert

# View with timestamps
sudo tail -f /var/log/snort/alert | grep -E "\[.*\]"
```

## 🔗 Integration Between Tools

### Wazuh + Suricata Integration
Wazuh automatically ingests Suricata alerts:
- **Location**: `/var/log/suricata/eve.json`
- **Format**: JSON
- **Wazuh Rules**: `/var/ossec/ruleset/rules/croc-suricata-rules.xml`

### Wazuh + Snort Integration
Wazuh automatically ingests Snort alerts:
- **Location**: `/var/log/snort/alert`
- **Format**: Syslog
- **Wazuh Rules**: `/var/ossec/ruleset/rules/croc-snort-rules.xml`

### Unified Dashboard
All alerts appear in Kibana:
- **URL**: https://127.0.0.1:5601
- **Dashboard**: CrocSec Threat Correlation
- **View**: Combined Wazuh, Suricata, and Snort alerts

## 📊 Monitoring & Analysis

### Kibana Dashboards
1. Navigate to: https://127.0.0.1:5601
2. Click: **CrocSec Threat Correlation**
3. View: Combined security events
4. Filter: By source (Wazuh, Suricata, Snort)

### Real-time Monitoring
```bash
# Monitor all IDS alerts
watch -n 5 'sudo tail -n 20 /var/log/suricata/eve.json | jq "select(.event_type==\"alert\")"'

# Monitor Wazuh alerts
croc-wazuh logs

# Monitor Snort alerts
croc-snort logs
```

## 🔧 Configuration Examples

### Suricata: Add Custom Rule
```bash
# Edit local rules
sudo nano /etc/suricata/rules/local.rules

# Add rule (example: detect SQL injection attempts)
alert http any any -> any any (msg:"SQL Injection Attempt"; content:"union select"; sid:1000002; rev:1;)

# Reload rules
croc-suricata reload
```

### Snort: Add Custom Rule
```bash
# Edit local rules
sudo nano /etc/snort/rules/local.rules

# Add rule (example: detect port scan)
alert tcp any any -> $HOME_NET any (flags:S; msg:"Port Scan Detected"; threshold:type threshold, track by_src, count 20, seconds 10; sid:1000002; rev:1;)

# Restart Snort
croc-snort restart
```

### Wazuh: Add Custom Rule
```bash
# Edit Wazuh rules
sudo nano /var/ossec/ruleset/rules/local_rules.xml

# Add rule (example: detect failed login attempts)
<rule id="100001" level="10">
  <if_sid>5710</if_sid>
  <match>authentication failure</match>
  <description>Multiple failed login attempts detected</description>
</rule>

# Restart Wazuh
croc-wazuh restart
```

## 🚀 Best Practices

### Performance Optimization
- **Suricata**: Use AF_PACKET for high performance
- **Snort**: Monitor single interface for better performance
- **Wazuh**: Tune Elasticsearch for your workload

### Rule Management
- **Update Regularly**: Keep rules up to date
- **Custom Rules**: Add organization-specific rules
- **Test Rules**: Test before deploying to production
- **Document Rules**: Document custom rules

### Alert Management
- **Tune Alerts**: Reduce false positives
- **Prioritize**: Focus on high-severity alerts
- **Correlate**: Use Wazuh to correlate alerts
- **Automate**: Set up automated responses

## 🆘 Troubleshooting

### Wazuh Issues
```bash
# Check service status
croc-wazuh status

# Check logs
sudo tail -f /var/ossec/logs/ossec.log

# Test configuration
croc-wazuh test

# Restart service
croc-wazuh restart
```

### Suricata Issues
```bash
# Check service status
croc-suricata status

# Check logs
sudo tail -f /var/log/suricata/suricata.log

# Test configuration
croc-suricata test-config

# Check interface
ip addr show
```

### Snort Issues
```bash
# Check service status
croc-snort status

# Check logs
sudo tail -f /var/log/snort/alert

# Test configuration
croc-snort test-config

# Check interface
ip addr show
```

## 📚 Additional Resources

### Documentation
- **Wazuh**: https://documentation.wazuh.com
- **Suricata**: https://suricata.readthedocs.io
- **Snort**: https://www.snort.org/documents

### Rule Sources
- **Suricata Rules**: https://rules.emergingthreats.net
- **Snort Rules**: https://www.snort.org/downloads
- **Wazuh Rules**: Included with installation

### Community
- **Wazuh Forum**: https://wazuh.com/community
- **Suricata Mailing List**: https://lists.openinfosecfoundation.org
- **Snort Community**: https://www.snort.org/community

---

**CrocLinux — The Silent Guardian of Cyber Defense** 🐊

**Quick Commands**:
- `croc-wazuh status` - Check Wazuh
- `croc-suricata status` - Check Suricata
- `croc-snort status` - Check Snort

