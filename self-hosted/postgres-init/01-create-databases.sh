#!/bin/bash
# =============================================================================
# Creates service databases on first PostgreSQL startup
# =============================================================================

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- Database for NocoDB
    CREATE DATABASE nocodb;
    GRANT ALL PRIVILEGES ON DATABASE nocodb TO $POSTGRES_USER;

    -- Database for n8n
    CREATE DATABASE n8n;
    GRANT ALL PRIVILEGES ON DATABASE n8n TO $POSTGRES_USER;

    -- Database for Metabase
    CREATE DATABASE metabase;
    GRANT ALL PRIVILEGES ON DATABASE metabase TO $POSTGRES_USER;
EOSQL

# Grant permissions for public schema in each database
for db in nocodb n8n metabase; do
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$db" <<-EOSQL
        GRANT ALL ON SCHEMA public TO $POSTGRES_USER;
EOSQL
done

echo "Service databases created successfully."
