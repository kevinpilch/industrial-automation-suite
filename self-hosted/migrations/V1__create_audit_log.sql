-- =============================================================================
-- V1: Baseline Migration
-- =============================================================================
-- Flyway manages migrations in the main database (automation).
-- Service databases (nocodb, n8n, metabase) are created via postgres-init.
-- This migration serves as a baseline for application-specific extensions.
-- =============================================================================

-- Audit log table for system-wide logging
CREATE TABLE IF NOT EXISTS audit_log (
    id BIGSERIAL PRIMARY KEY,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    service VARCHAR(50) NOT NULL,
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(100),
    entity_id VARCHAR(255),
    user_id VARCHAR(255),
    details JSONB,
    ip_address INET
);

CREATE INDEX idx_audit_log_timestamp ON audit_log(timestamp);
CREATE INDEX idx_audit_log_service ON audit_log(service);
CREATE INDEX idx_audit_log_entity ON audit_log(entity_type, entity_id);

COMMENT ON TABLE audit_log IS 'Central audit logging for all services';
