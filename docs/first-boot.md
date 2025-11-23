# CrocLinux First Boot Experience

## Welcome Banner
Upon login, CrocLinux displays the crocodile ASCII banner to set the SOC-branded tone. `/etc/issue` and `/etc/motd` present:

```
        ___.-~~~~-.
  _/\  `~-._____'_____  ___
 {  `\         \      `' _ `.
  \   |  CROCODILE JAWS  ( | )
   `\ |    >>>  <<<      _\_/
     \|   ________   _.-'  \
      |  /  __   /\ /   _   \
      | /  /_/  /  Y  /_/\   \
      |/\______/\__|_/ /_/\___\

  ____                _     _                  
 / ___|_ __ ___   ___| |   (_)_ __  _   ___  __
| |   | '__/ _ \ / __| |   | | '_ \| | | \ \/ /
| |___| | | (_) | (__| |___| | | | | |_| |>  < 
 \____|_|  \___/ \___|_____|_|_| |_|\__,_/_/\_\
                                               

  CrocLinux — The Silent Guardian of Cyber Defense
```

## Desktop Environment
- **Xfce Panel** pre-configured with Applications menu, task list, separator, and system tray.
- **Dark Theme** tuned for low-light SOC monitoring rooms.
- **CrocSec Dashboard Launcher** placed on the desktop for immediate access to Kibana dashboards.
- **Autostart Terminal** opens with `watch` output of SOC service status:
  ```
  sudo systemctl --no-pager status wazuh-manager suricata thehive cortex velociraptor
  ```

## Services Snapshot
Key services start automatically:
- `wazuh-manager`, `filebeat`, `elasticsearch`, `kibana`
- `misp-workers`, `redis-server`, `mariadb`
- `thehive`, `cortex`, `velociraptor`, `grr-server`
- `suricata`, `osqueryd`, `sysmonforlinux`
- `ufw`, `apparmor`, `auditd`, `fail2ban`

Verify status with:
```bash
sudo systemctl status wazuh-manager elasticsearch kibana misp-workers thehive cortex suricata
```

## CrocSec CLI
The assistant provides intent-based shortcuts:
```bash
crocsec summary
crocsec status
crocsec update_rules
```

## Automation Timers
Check the MISP-Wazuh sync schedule:
```bash
systemctl list-timers croc-misp-sync.timer
```

## Next Steps for Analysts
1. Replace placeholder credentials (`CHANGEME`, API keys).
2. Import organization-specific Sigma/YARA rules via `croc-update-rules`.
3. Enroll hosts using Wazuh agent or OSQuery packages from `/var/ossec`. 
4. Configure Kibana index patterns for `wazuh-alerts-*` if not auto-created.
5. Connect TheHive to Cortex analyzers and configure automation playbooks.

> CrocLinux ships with default self-signed certificates. Replace them with enterprise-provisioned certs when deploying in production.
