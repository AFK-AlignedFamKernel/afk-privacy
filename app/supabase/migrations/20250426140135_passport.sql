-- Drop existing indexes first
DROP INDEX IF EXISTS idx_passport_registrations_pubkey;
DROP INDEX IF EXISTS idx_passport_registrations_group_id;
DROP INDEX IF EXISTS idx_passport_registrations_provider;

-- Drop existing table
DROP TABLE IF EXISTS passport_registrations;

-- Create tables with proper relationships and constraints
CREATE TABLE IF NOT EXISTS passport_registrations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    provider TEXT NOT NULL,
    pubkey TEXT NOT NULL,
    id_register TEXT,
    proof JSONB NOT NULL,
    proof_args JSONB NOT NULL,
    group_id TEXT NOT NULL,
    nationality TEXT,
    date_of_birth TEXT,
    gender TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(pubkey, group_id, provider)
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_passport_registrations_pubkey ON passport_registrations(pubkey);
CREATE INDEX IF NOT EXISTS idx_passport_registrations_group_id ON passport_registrations(group_id);
CREATE INDEX IF NOT EXISTS idx_passport_registrations_provider ON passport_registrations(provider);
