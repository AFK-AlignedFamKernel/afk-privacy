-- Enable Row Level Security
-- ALTER DATABASE postgres SET "app.jwt_secret" TO 'your-jwt-secret-here';

-- Create tables with proper relationships and constraints
CREATE TABLE IF NOT EXISTS memberships (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    provider TEXT NOT NULL,
    pubkey TEXT NOT NULL,
    pubkey_expiry TIMESTAMPTZ NOT NULL,
    proof JSONB NOT NULL,
    proof_args JSONB NOT NULL,
    group_id TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(pubkey, group_id, provider)
);

CREATE TABLE IF NOT EXISTS messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id TEXT NOT NULL,
    group_provider TEXT NOT NULL,
    text TEXT NOT NULL,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    signature TEXT NOT NULL,
    pubkey TEXT NOT NULL,
    internal BOOLEAN NOT NULL DEFAULT false,
    likes INTEGER NOT NULL DEFAULT 0,
    tweeted BOOLEAN NOT NULL DEFAULT false,
    membership_id UUID REFERENCES memberships(id) ON DELETE CASCADE,
    CONSTRAINT fk_message_membership 
        FOREIGN KEY (pubkey, group_id, group_provider) 
        REFERENCES memberships(pubkey, group_id, provider)
);

CREATE TABLE IF NOT EXISTS likes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    message_id UUID NOT NULL REFERENCES messages(id) ON DELETE CASCADE,
    pubkey TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(message_id, pubkey)
);

-- Create functions for likes
CREATE OR REPLACE FUNCTION increment_likes_count(message_id UUID)
RETURNS void AS $$
BEGIN
    UPDATE messages SET likes = likes + 1 WHERE id = message_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION decrement_likes_count(message_id UUID)
RETURNS void AS $$
BEGIN
    UPDATE messages SET likes = likes - 1 WHERE id = message_id;
END;
$$ LANGUAGE plpgsql;

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_messages_group_id ON messages(group_id);
CREATE INDEX IF NOT EXISTS idx_messages_timestamp ON messages(timestamp);
CREATE INDEX IF NOT EXISTS idx_messages_pubkey ON messages(pubkey);
CREATE INDEX IF NOT EXISTS idx_messages_membership ON messages(pubkey, group_id, group_provider);
CREATE INDEX IF NOT EXISTS idx_memberships_pubkey ON memberships(pubkey);
CREATE INDEX IF NOT EXISTS idx_memberships_group_id ON memberships(group_id);
CREATE INDEX IF NOT EXISTS idx_memberships_composite ON memberships(pubkey, group_id, provider);
CREATE INDEX IF NOT EXISTS idx_likes_message_id ON likes(message_id);
CREATE INDEX IF NOT EXISTS idx_likes_pubkey ON likes(pubkey);

-- Enable Row Level Security
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE memberships ENABLE ROW LEVEL SECURITY;
ALTER TABLE likes ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Allow public read access to non-internal messages"
    ON messages FOR SELECT
    USING (internal = false);

CREATE POLICY "Allow authenticated users to read internal messages"
    ON messages FOR SELECT
    USING (
        internal = true AND
        EXISTS (
            SELECT 1 FROM memberships
            WHERE memberships.pubkey = current_setting('request.jwt.claims', true)::json->>'pubkey'
            AND memberships.group_id = messages.group_id
        )
    );

CREATE POLICY "Allow authenticated users to insert messages"
    ON messages FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM memberships
            WHERE memberships.pubkey = messages.pubkey
            AND memberships.group_id = messages.group_id
            AND memberships.provider = messages.group_provider
            AND memberships.pubkey_expiry > NOW()
        )
    );

CREATE POLICY "Allow public read access to memberships"
    ON memberships FOR SELECT
    USING (true);

CREATE POLICY "Allow authenticated users to insert memberships"
    ON memberships FOR INSERT
    WITH CHECK (true);

CREATE POLICY "Allow authenticated users to read likes"
    ON likes FOR SELECT
    USING (true);

CREATE POLICY "Allow authenticated users to insert likes"
    ON likes FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM memberships
            WHERE memberships.pubkey = current_setting('request.jwt.claims', true)::json->>'pubkey'
        )
    );

CREATE POLICY "Allow authenticated users to delete likes"
    ON likes FOR DELETE
    USING (
        pubkey = current_setting('request.jwt.claims', true)::json->>'pubkey'
    );