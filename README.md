# Industrial Automation Suite

Eine Open-Source Automatisierungsplattform. DB, Workflows, Analytics und Monitoring & Alerting in einem kostenlosen Stack.

## Komponenten

| Service | Beschreibung |
|---------|--------------|
| **PostgreSQL 16** | Zentrale Datenbank |
| **NocoDB** | Datenbank-Frontend (Airtable-Alternative) |
| **n8n** | Workflow-Automatisierung |
| **Metabase** | Analytics und Reporting |
| **Uptime Kuma** | Monitoring und Alerting |
| **Flyway** | Datenbank-Migrationen |

## Deployment-Optionen

### Option 1: Lokale Installation (Docker Compose)

Für schnelles Testen oder Entwicklung auf dem eigenen Rechner.

**Voraussetzungen:**
- Docker >= 20.10
- Docker Compose >= 2.0

**Installation:**

```bash
cd self-hosted
./setup.sh
```

Das Setup-Skript:
1. Generiert automatisch sichere Secrets
2. Erstellt die `.env` Konfigurationsdatei
3. Startet alle Services

**Service-Zugriff (lokal):**

| Service | URL |
|---------|-----|
| NocoDB | http://localhost:8080 |
| n8n | http://localhost:5678 |
| Metabase | http://localhost:3000 |
| Uptime Kuma | http://localhost:3001 |

**Verwaltung:**

```bash
cd self-hosted

# Status anzeigen
docker compose ps

# Logs verfolgen
docker compose logs -f

# Services stoppen
docker compose down

# Alles löschen (inkl. Daten)
docker compose down -v
```

---

### Option 2: Server-Deployment mit Ansible

Für produktionsnahe Umgebungen auf einem dedizierten Server (z.B. Raspberry Pi).

**Voraussetzungen:**

*Control-Rechner (z.B. Laptop):*
- Ansible >= 2.15
- Python 3.10+
- SSH-Zugang zum Ziel-Server

*Ziel-Server:*
- Debian-basiertes OS (Raspberry Pi OS, Ubuntu, Debian)
- SSH-Zugang mit sudo-Rechten

**Installation:**

```bash
cd self-hosted/ansible

# 1. Inventory anpassen
nano inventory/hosts.yml
```

Server-Adresse und Benutzer eintragen:

```yaml
all:
  hosts:
    piserver:
      ansible_host: piserver.local    # oder IP-Adresse
      ansible_user: kevin             # SSH-Benutzer
      ansible_ssh_private_key_file: ~/.ssh/id_ed25519
```

```bash
# 2. Vault-Passwort erstellen
echo "mein-sicheres-passwort" > ~/.vault_pass
chmod 600 ~/.vault_pass

# 3. Secrets generieren und verschlüsseln
cp inventory/group_vars/all/vault.yml.example inventory/group_vars/all/vault.yml

# Secrets generieren (4x ausführen)
openssl rand -hex 32

# Secrets in vault.yml eintragen
nano inventory/group_vars/all/vault.yml

# Vault verschlüsseln
ansible-vault encrypt inventory/group_vars/all/vault.yml

# 4. Deployment ausführen
ansible-playbook playbooks/site.yml
```

**Service-Zugriff (Server):**

Ersetze `<server>` mit deinem Hostnamen oder IP-Adresse:

| Service | URL |
|---------|-----|
| NocoDB | http://\<server\>:8080 |
| n8n | http://\<server\>:5678 |
| Metabase | http://\<server\>:3000 |
| Uptime Kuma | http://\<server\>:3001 |

**Ansible-Rollen:**

| Rolle | Beschreibung |
|-------|--------------|
| `base` | System-Grundkonfiguration, Firewall, Pakete |
| `docker` | Docker CE Installation (Architektur-unabhängig) |
| `automation-stack` | Docker Compose Stack Deployment |

**Verwaltung auf dem Server:**

```bash
cd /opt/automation-stack

# Status anzeigen
docker compose ps

# Logs verfolgen
docker compose logs -f [service]

# Service neustarten
docker compose restart [service]

# Services stoppen
docker compose down
```

---

### Option 3: AWS (Coming Soon)

Cloud-Deployment auf AWS mit Terraform.

*Diese Option ist noch in Entwicklung.*

---

## Datenbank-Struktur

PostgreSQL enthält separate Datenbanken für jeden Service:

| Datenbank | Verwendung |
|-----------|------------|
| `automation` | Hauptdatenbank, Flyway-Migrationen, Audit-Log |
| `nocodb` | NocoDB Metadaten und Benutzerdaten |
| `n8n` | n8n Workflows und Credentials |
| `metabase` | Metabase Konfiguration |

## Migrationen

Datenbank-Migrationen werden mit Flyway verwaltet.

**Neue Migration hinzufügen:**

```bash
# Lokal
self-hosted/migrations/V2__meine_migration.sql

# Ansible
self-hosted/ansible/roles/automation-stack/files/migrations/V2__meine_migration.sql
```

Namenskonvention: `V{version}__{beschreibung}.sql`

## Backup

```bash
cd /opt/automation-stack  # oder self-hosted/

# Backup erstellen
docker compose exec postgres pg_dumpall -U automation > backup.sql

# Backup wiederherstellen
cat backup.sql | docker compose exec -T postgres psql -U automation
```

## Volumes

Persistente Daten werden in Docker Volumes gespeichert:

| Volume | Inhalt |
|--------|--------|
| `automation-postgres-data` | PostgreSQL Daten |
| `automation-nocodb-data` | NocoDB Dateien |
| `automation-n8n-data` | n8n Workflows |
| `automation-metabase-data` | Metabase Konfiguration |
| `automation-uptime-kuma-data` | Uptime Kuma Daten |

## Lizenz

MIT License - siehe [LICENSE](LICENSE)
