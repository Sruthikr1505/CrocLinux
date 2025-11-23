# CrocLinux System Architecture

```
                    +---------------------------+
                    |       Threat Feeds        |
                    |  (OpenCTI, MISP sharing)  |
                    +-------------+-------------+
                                  |
                                  | IOC Sync (croc-misp-sync.service / timer)
                                  v
+-------------------+      +------+-------+       +-----------------------+
| CrocSec CLI       |      |   MISP Core  |       |   Wazuh Manager       |
| (analyst console) |<---->|  Intel Store |<----->|  Detection + Rules    |
+---------+---------+      +------+-------+       +----+------------------+
          |                        |                    |
          |                        | Filebeat           | Agent Events
          |                        v                    v
          |                +-------+-------+    +-------+-------+
          |                |  TheHive +    |    | Suricata IDS  |
          |                |  Cortex SOAR  |    | (af-packet)   |
          |                +-------+-------+    +-------+-------+
          |                        |                    |
          |                        | Tasking            | Alerts (EVE)
          |                        v                    v
          |                +-------+-------+    +-------+-------+
          |                | Velociraptor  |    |  OSQuery &    |
          |                | & GRR Hunt    |    |  Sysmon4Linux |
          |                +-------+-------+    +-------+-------+
          |                        |                    |
          +------------------------+--------------------+
                                   |
                                   v
                           +-------+-------+
                           | Elasticsearch |
                           | Ingest + SIEM |
                           +-------+-------+
                                   |
                                   | Kibana / CrocSec Dashboard
                                   v
                           +-------+-------+
                           |  SOC Analysts |
                           |  Dashboards   |
                           +---------------+
```

## Data Flow Summary
- Suricata, OSQuery, Sysmon, and Wazuh agents feed telemetry into Wazuh Manager.
- Filebeat streams enriched alerts into Elasticsearch for Kibana visualization.
- MISP serves threat intelligence and syncs IOCs to Wazuh using the CrocLinux automation timer.
- TheHive/Cortex manage incident workflows, with optional Velociraptor/GRR tasking for endpoint collection.
- CrocSec CLI and Dashboard act as the analyst control layer.

## Security Controls
- AppArmor enforces service confinement.
- UFW manages host firewall defaults with explicit allowances for SOC services.
- Auditd monitors privileged activity, while Fail2Ban protects SSH.

## Extensibility Points
- AI anomaly detection module will ingest from Elasticsearch and write back into Wazuh.
- Secure cloud sync will mirror Elasticsearch indices and MISP data to offsite storage.
- Docker Compose stack mirrors on-host services for distributed deployments.
