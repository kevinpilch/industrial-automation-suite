#!/bin/bash
# =============================================================================
# Industrial Automation Suite - Local Setup Script
# =============================================================================
# This script sets up the automation suite for local development/testing.
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "=== Industrial Automation Suite Setup ==="
echo

# Check for Docker
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed. Please install Docker first."
    exit 1
fi

# Check for Docker Compose
if ! docker compose version &> /dev/null; then
    echo "Error: Docker Compose is not available. Please install Docker Compose."
    exit 1
fi

# Create .env if it doesn't exist
if [ ! -f .env ]; then
    echo "Creating .env file with generated secrets..."

    POSTGRES_PASSWORD=$(openssl rand -hex 32)
    NOCODB_JWT_SECRET=$(openssl rand -hex 32)
    N8N_ENCRYPTION_KEY=$(openssl rand -hex 32)
    METABASE_SECRET_KEY=$(openssl rand -hex 32)

    cat > .env << EOF
# =============================================================================
# Industrial Automation Suite - Configuration
# =============================================================================
# Generated automatically by setup.sh
# =============================================================================

# PostgreSQL
POSTGRES_USER=automation
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
POSTGRES_DB=automation

# NocoDB
NOCODB_JWT_SECRET=${NOCODB_JWT_SECRET}
NOCODB_PORT=8080
NOCODB_PUBLIC_URL=http://localhost:8080

# n8n
N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY}
N8N_PORT=5678
N8N_HOST=localhost
N8N_PROTOCOL=http
N8N_WEBHOOK_URL=http://localhost:5678

# Metabase
METABASE_SECRET_KEY=${METABASE_SECRET_KEY}
METABASE_PORT=3000

# Uptime Kuma
UPTIME_KUMA_PORT=3001

# General
TIMEZONE=Europe/Berlin
EOF

    echo ".env file created with secure random secrets."
else
    echo ".env file already exists. Skipping secret generation."
fi

echo
echo "Starting services..."
docker compose up -d

echo
echo "=== Setup Complete ==="
echo
echo "Services are starting up. Please wait a moment for all services to be ready."
echo
echo "Access the services at:"
echo "  - NocoDB:      http://localhost:8080"
echo "  - n8n:         http://localhost:5678"
echo "  - Metabase:    http://localhost:3000  (takes ~1-2 min to start)"
echo "  - Uptime Kuma: http://localhost:3001"
echo
echo "Useful commands:"
echo "  docker compose ps      - Show service status"
echo "  docker compose logs -f - Follow logs"
echo "  docker compose down    - Stop all services"
echo "  docker compose down -v - Stop and remove all data"
