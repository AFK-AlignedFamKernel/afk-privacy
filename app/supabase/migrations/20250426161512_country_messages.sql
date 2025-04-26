CREATE TABLE IF NOT EXISTS country_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    text TEXT NOT NULL,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    signature TEXT NOT NULL,
    pubkey TEXT NOT NULL,
    likes INTEGER NOT NULL DEFAULT 0,
    tweeted BOOLEAN NOT NULL DEFAULT false,
    parent_id UUID REFERENCES country_messages(id) ON DELETE CASCADE,
    reply_count INTEGER NOT NULL DEFAULT 0,
    ephemeral_key_id UUID REFERENCES ephemeral_keys(id) ON DELETE CASCADE,
    passport_registration_id UUID REFERENCES passport_registrations(id) ON DELETE CASCADE,
    nationality TEXT,
    date_of_birth TEXT,
    gender TEXT,
    -- CONSTRAINT fk_ephemeral_key
    --     FOREIGN KEY (pubkey)
    --     REFERENCES ephemeral_keys(pubkey)
);

CREATE INDEX IF NOT EXISTS idx_country_messages_nationality ON country_messages(nationality);
CREATE INDEX IF NOT EXISTS idx_country_messages_date_of_birth ON country_messages(date_of_birth);
CREATE INDEX IF NOT EXISTS idx_country_messages_gender ON country_messages(gender);
CREATE INDEX IF NOT EXISTS idx_country_messages_ephemeral_key_id ON country_messages(ephemeral_key_id);
CREATE INDEX IF NOT EXISTS idx_country_messages_passport_registration_id ON country_messages(passport_registration_id);
CREATE INDEX IF NOT EXISTS idx_country_messages_pubkey ON country_messages(pubkey);