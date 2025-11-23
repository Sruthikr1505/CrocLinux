# CrocLinux Roadmap

## Q1 2026
- **AI-Assisted Detection Module**
  - Integrate GPU-enabled anomaly detection pipeline using Elastic ML jobs.
  - Feed results back into Wazuh as custom rules for automated alerting.
- **CrocSec Chatbot v2**
  - Natural language command recognition with playbook execution hooks.
  - Integration with Slack/MSTeams for SOC collaboration.

## Q2 2026
- **Secure Cloud Sync**
  - Encrypted replication of Elasticsearch indices to S3-compatible storage.
  - Optional mirroring of MISP events via Zero Trust tunnels.
- **Sensor Fleet Images**
  - Docker/Podman images for lightweight CrocLinux sensor nodes (OSQuery, Suricata, Wazuh agent).
  - Automated enrollment scripts for large-scale deployments.

## Q3 2026
- **Incident Response Playbooks**
  - Docs and automation for ransomware, credential theft, lateral movement scenarios.
  - TheHive/Cortex templates with pre-populated tasks.
- **Threat Hunting Workbench**
  - Custom Kibana workspaces and Jupyter integration for ad-hoc analysis.

## Q4 2026
- **Zero Trust Enhancements**
  - Mutual TLS enforcement across all internal services.
  - Hardware-backed secret management using TPM/YubiHSM.
- **Compliance Packs**
  - Pre-built dashboards and alert rules for SOC2, ISO 27001, PCI-DSS.

## Backlog / Ideas
- Offline update appliance for air-gapped SOCs.
- Windows/macOS agent management console.
- Community rule marketplace for sharing CrocLinux-tailored Sigma/YARA bundles.

> Roadmap is iterative; priorities adjust with community feedback and sponsor requirements.
