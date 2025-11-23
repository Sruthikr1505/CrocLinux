# CrocLinux Default Credentials and Services

| Component / Service        | Access URL / Port             | Default Credential / Note                    |
|---------------------------|-------------------------------|----------------------------------------------|
| OS Login (local)          | Console / SSH                 | `analyst / Croc!2025` (SSH password disabled) |
| sudo                      | Local                         | `analyst` is sudo-enabled                     |
| Kibana (CrocSec Dashboard)| https://127.0.0.1:5601        | `elastic / CHANGEME`                          |
| Elasticsearch             | https://127.0.0.1:9200        | `elastic / CHANGEME`                          |
| Wazuh API                 | https://127.0.0.1:55000       | `wazuh / CHANGE_ME`                           |
| MISP                      | https://127.0.0.1             | `admin@croc.local / Croc!2025`                |
| TheHive                   | http://127.0.0.1:9000         | Create admin on first login                  |
| Cortex                    | http://127.0.0.1:9001         | Create admin on first login                  |
| Velociraptor (GUI)        | https://127.0.0.1:8000        | Generated during first run (see `/var/lib/velociraptor`) |
| Suricata EVE socket       | `/var/run/suricata/eve.sock`   | Consumed by Filebeat                         |
| CrocSec CLI               | `/usr/local/bin/crocsec`       | Intents: `summary`, `status`, `update_rules`, `investigate` |
| Croc MISP Sync Timer      | `croc-misp-sync.timer`         | Runs hourly                                  |

## Enabled Services
- **Security Framework:** `ufw`, `apparmor`, `auditd`, `fail2ban`
- **SOC Stack:** `wazuh-manager`, `filebeat`, `elasticsearch`, `kibana`, `misp-workers`, `redis-server`, `mariadb`, `thehive`, `cortex`, `velociraptor`, `grr-server`, `suricata`, `osqueryd`, `sysmonforlinux`
- **System Utilities:** `NetworkManager`, `lightdm`, `ssh`

## Ports Opened by UFW
- `22/tcp` – SSH (for remote management)
- `5601/tcp` – Kibana (CrocSec Dashboard)
- `9200/tcp` – Elasticsearch
- `55000/tcp` – Wazuh API / agent enrollment
- `1514/udp` – Wazuh syslog ingestion

> Update all placeholder credentials (`CHANGEME`, `CHANGE_ME`) immediately after installation.
