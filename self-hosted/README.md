# Industrial Automation Suite - Self-Hosted

Self-Hosted Deployment der Industrial Automation Suite.

## Schnellstart (Lokal)

```bash
./setup.sh
```

## Service-Zugriff

Nach dem Start sind die Services unter folgenden URLs erreichbar:

| Service | URL | Beschreibung |
|---------|-----|--------------|
| **NocoDB** | http://localhost:8080 | Datenbank-Frontend (Airtable-Alternative) |
| **n8n** | http://localhost:5678 | Workflow-Automatisierung |
| **Metabase** | http://localhost:3000 | Analytics und Reporting |
| **Uptime Kuma** | http://localhost:3001 | Monitoring und Alerting |

> **Hinweis:** Metabase benötigt ca. 1-2 Minuten zum Starten (Java-basiert).

## Verwaltung

```bash
# Status anzeigen
docker compose ps

# Logs verfolgen
docker compose logs -f

# Einzelnen Service neustarten
docker compose restart [service]

# Services stoppen
docker compose down

# Alles löschen (inkl. Daten!)
docker compose down -v
```

## Server-Deployment mit Ansible

Für Deployment auf einem dedizierten Server (z.B. Raspberry Pi) siehe `ansible/` Verzeichnis.

```bash
cd ansible
ansible-playbook playbooks/site.yml
```

### Service-Zugriff (Server)

Ersetze `<server>` mit dem Hostnamen oder der IP-Adresse deines Servers:

| Service | URL |
|---------|-----|
| **NocoDB** | http://\<server\>:8080 |
| **n8n** | http://\<server\>:5678 |
| **Metabase** | http://\<server\>:3000 |
| **Uptime Kuma** | http://\<server\>:3001 |

## Weitere Dokumentation

Siehe [Haupt-README](../README.md) für vollständige Dokumentation.
