-- Drop existing indexes first
DROP INDEX IF EXISTS idx_passport_registrations_pubkey;
DROP INDEX IF EXISTS idx_passport_registrations_group_id;
DROP INDEX IF EXISTS idx_passport_registrations_provider;

-- Drop existing table
DROP TABLE IF EXISTS passport_registrations;

-- Create tables with proper relationships and constraints
CREATE TABLE IF NOT EXISTS ephemeral_keys (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pubkey TEXT NOT NULL,
    signature TEXT NOT NULL,
    proof JSONB,
    uuid TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(pubkey)
);

-- Create tables with proper relationships and constraints
CREATE TABLE IF NOT EXISTS passport_registrations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    provider TEXT NOT NULL,
    pubkey TEXT NOT NULL,
    id_register TEXT,
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    proof JSONB,
    proof_args JSONB,
    group_id TEXT NOT NULL,
    nationality TEXT,
    date_of_birth TEXT,
    gender TEXT,
    signature TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ephemeral_key_id UUID NOT NULL REFERENCES ephemeral_keys(id),
    UNIQUE(pubkey, group_id, provider),
    UNIQUE(ephemeral_key_id) -- Ensures one-to-one relationship
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_passport_registrations_pubkey ON passport_registrations(pubkey);
CREATE INDEX IF NOT EXISTS idx_passport_registrations_group_id ON passport_registrations(group_id);
CREATE INDEX IF NOT EXISTS idx_passport_registrations_provider ON passport_registrations(provider);
