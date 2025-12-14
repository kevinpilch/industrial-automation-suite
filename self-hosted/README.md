# Industrial Automation Suite - Self-Hosted

Self-Hosted Variante der Industrial Automation Suite für R&D-Umgebungen.

## Komponenten

| Service | Port | Beschreibung |
|---------|------|--------------|
| PostgreSQL 16 | 5432 | Zentrale Datenbank |
| NocoDB | 8080 | Datenbank-Frontend (Airtable-Alternative) |
| n8n | 5678 | Workflow Automation |
| Metabase | 3000 | Analytics und Reporting |
| Uptime Kuma | 3001 | Monitoring und Alerting |
| Flyway | - | Datenbank-Migrationen |

## Voraussetzungen

- Docker >= 20.10
- Docker Compose >= 2.0

## Installation

```bash
# 1. Konfiguration erstellen
cp .env.example .env

# 2. Sichere Secrets generieren
openssl rand -hex 32  # Für NOCODB_JWT_SECRET
openssl rand -hex 32  # Für N8N_ENCRYPTION_KEY
openssl rand -hex 32  # Für METABASE_SECRET_KEY

# 3. .env Datei anpassen (Passwörter und Secrets eintragen)
nano .env

# 4. Services starten
docker compose up -d
```

## Zugriff

Nach dem Start sind die Services unter folgenden URLs erreichbar:

- **NocoDB**: http://localhost:8080
- **n8n**: http://localhost:5678
- **Metabase**: http://localhost:3000
- **Uptime Kuma**: http://localhost:3001

## Datenbank-Struktur

PostgreSQL enthält separate Datenbanken für jeden Service:

| Datenbank | Verwendung |
|-----------|------------|
| `automation` | Hauptdatenbank, Flyway-Migrationen |
| `nocodb` | NocoDB Metadaten und Benutzerdaten |
| `n8n` | n8n Workflows und Credentials |
| `metabase` | Metabase Konfiguration |

## Migrationen

Datenbank-Migrationen werden mit Flyway verwaltet. Neue Migrationen im `migrations/` Ordner ablegen:

```
migrations/
├── V1__create_service_databases.sql
├── V2__your_migration.sql
└── V3__another_migration.sql
```

Namenskonvention: `V{version}__{beschreibung}.sql`

Migrationen manuell ausführen:

```bash
docker compose run --rm flyway migrate
```

## Verwaltung

```bash
# Status aller Services
docker compose ps

# Logs anzeigen
docker compose logs -f [service]

# Service neustarten
docker compose restart [service]

# Alle Services stoppen
docker compose down

# Alle Services inkl. Volumes löschen (DATENVERLUST!)
docker compose down -v
```

## Backup

```bash
# PostgreSQL Backup erstellen
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
