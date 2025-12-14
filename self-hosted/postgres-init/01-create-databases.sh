#!/bin/bash
# =============================================================================
# Erstellt die Service-Datenbanken beim ersten Start von PostgreSQL
# =============================================================================

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- Datenbank für NocoDB
    CREATE DATABASE nocodb;
    GRANT ALL PRIVILEGES ON DATABASE nocodb TO $POSTGRES_USER;

    -- Datenbank für n8n
    CREATE DATABASE n8n;
    GRANT ALL PRIVILEGES ON DATABASE n8n TO $POSTGRES_USER;

    -- Datenbank für Metabase
    CREATE DATABASE metabase;
    GRANT ALL PRIVILEGES ON DATABASE metabase TO $POSTGRES_USER;
EOSQL

# Berechtigungen für public schema in jeder Datenbank
for db in nocodb n8n metabase; do
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$db" <<-EOSQL
        GRANT ALL ON SCHEMA public TO $POSTGRES_USER;
EOSQL
done

echo "Service-Datenbanken erfolgreich erstellt."
