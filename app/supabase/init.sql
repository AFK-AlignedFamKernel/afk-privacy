-- Enable Row Level Security
-- ALTER DATABASE postgres SET "app.jwt_secret" TO 'your-jwt-secret-here';
-- Drop existing tables if they exist

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
    zk_identity JSONB,
    zk_provider TEXT,   
    zk_identity_expiry TIMESTAMPTZ,
    is_verified BOOLEAN NOT NULL DEFAULT false,
    uuid TEXT,
    nationality TEXT,
    date_of_birth TEXT,
    gender TEXT,
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
    parent_id UUID REFERENCES messages(id) ON DELETE CASCADE,
    reply_count INTEGER NOT NULL DEFAULT 0,
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

-- Create function to update reply count
CREATE OR REPLACE FUNCTION update_reply_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' AND NEW.parent_id IS NOT NULL THEN
        -- When inserting a comment, increment the parent's reply count
        UPDATE messages 
        SET reply_count = reply_count + 1 
        WHERE id = NEW.parent_id;
    ELSIF TG_OP = 'DELETE' AND OLD.parent_id IS NOT NULL THEN
        -- When deleting a comment, decrement the parent's reply count
        UPDATE messages 
        SET reply_count = reply_count - 1 
        WHERE id = OLD.parent_id;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create separate triggers for INSERT and DELETE
CREATE TRIGGER update_reply_count_insert_trigger
    AFTER INSERT ON messages
    FOR EACH ROW
    EXECUTE FUNCTION update_reply_count();

CREATE TRIGGER update_reply_count_delete_trigger
    AFTER DELETE ON messages
    FOR EACH ROW
    EXECUTE FUNCTION update_reply_count();

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_messages_group_id ON messages(group_id);
CREATE INDEX IF NOT EXISTS idx_messages_timestamp ON messages(timestamp);
CREATE INDEX IF NOT EXISTS idx_messages_pubkey ON messages(pubkey);
CREATE INDEX IF NOT EXISTS idx_messages_parent_id ON messages(parent_id);
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

-- Drop existing indexes first
DROP INDEX IF EXISTS idx_passport_registrations_pubkey;
DROP INDEX IF EXISTS idx_passport_registrations_group_id;
DROP INDEX IF EXISTS idx_passport_registrations_provider;
DROP INDEX IF EXISTS idx_ephemeral_keys_pubkey;

-- Drop existing table
DROP TABLE IF EXISTS passport_registrations;
DROP TABLE IF EXISTS ephemeral_keys;

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
CREATE INDEX IF NOT EXISTS idx_ephemeral_keys_pubkey ON ephemeral_keys(pubkey);


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
    group_id TEXT NOT NULL,
    group_provider TEXT NOT NULL,
    internal BOOLEAN NOT NULL DEFAULT false
);

CREATE INDEX IF NOT EXISTS idx_country_messages_nationality ON country_messages(nationality);
CREATE INDEX IF NOT EXISTS idx_country_messages_date_of_birth ON country_messages(date_of_birth);
CREATE INDEX IF NOT EXISTS idx_country_messages_gender ON country_messages(gender);
CREATE INDEX IF NOT EXISTS idx_country_messages_ephemeral_key_id ON country_messages(ephemeral_key_id);
CREATE INDEX IF NOT EXISTS idx_country_messages_passport_registration_id ON country_messages(passport_registration_id);
CREATE INDEX IF NOT EXISTS idx_country_messages_pubkey ON country_messages(pubkey);
CREATE INDEX IF NOT EXISTS idx_country_messages_group_id ON country_messages(group_id);
CREATE INDEX IF NOT EXISTS idx_country_messages_group_provider ON country_messages(group_provider);

-- Add new columns to polls table to match membership attributes
ALTER TABLE memberships
ADD COLUMN zk_identity JSONB,
ADD COLUMN zk_provider TEXT,
ADD COLUMN nationality TEXT,
ADD COLUMN date_of_birth TEXT,
ADD COLUMN gender TEXT,
ADD COLUMN uuid TEXT,
ADD COLUMN is_verified BOOLEAN DEFAULT false;




    -- Drop existing table
DROP TABLE IF EXISTS polls;
DROP TABLE IF EXISTS poll_options;
DROP TABLE IF EXISTS poll_votes;


-- Create polls table
CREATE TABLE IF NOT EXISTS polls (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id TEXT NOT NULL,
    group_provider TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    is_yes_no BOOLEAN NOT NULL DEFAULT false,
    max_options INTEGER NOT NULL DEFAULT 1,
    min_options INTEGER NOT NULL DEFAULT 1,
    answer_options TEXT[] NOT NULL DEFAULT '{}',
    is_nationality BOOLEAN NOT NULL DEFAULT false,
    selected_countries TEXT[],
    internal BOOLEAN NOT NULL DEFAULT false,
    is_public_result BOOLEAN NOT NULL DEFAULT false,
    selected_organizations TEXT[],
    multiselect BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ends_at TIMESTAMPTZ NOT NULL,
    creator_pubkey TEXT NOT NULL,
    is_show_results_publicly BOOLEAN NOT NULL DEFAULT false,
    membership_id UUID REFERENCES memberships(id) ON DELETE CASCADE,
    is_only_organizations BOOLEAN,
    is_only_kyc_verified BOOLEAN,
    age_required INTEGER,
    is_specific_countries BOOLEAN,
    countries_accepted TEXT[],
    countries_excluded TEXT[],
    total_vote_organization INTEGER,
    total_vote_membership INTEGER,
    total_vote_kyc INTEGER,
    total_vote_nationalityg INTEGER,
    passport_registration_id UUID REFERENCES passport_registrations(id) ON DELETE CASCADE,
    CONSTRAINT fk_poll_membership
        FOREIGN KEY (creator_pubkey, group_id, group_provider) 
        REFERENCES memberships(pubkey, group_id, provider)
);

-- Create poll options/answers table
CREATE TABLE IF NOT EXISTS poll_options (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    poll_id UUID NOT NULL REFERENCES polls(id) ON DELETE CASCADE,
    option_text TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create poll votes table with one vote per user constraint
CREATE TABLE IF NOT EXISTS poll_votes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    poll_id UUID NOT NULL REFERENCES polls(id) ON DELETE CASCADE,
    option_id UUID NOT NULL REFERENCES poll_options(id) ON DELETE CASCADE,
    voter_pubkey TEXT NOT NULL,
    group_id TEXT NOT NULL,
    group_provider TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    membership_id UUID REFERENCES memberships(id) ON DELETE CASCADE,
    passport_registration_id UUID REFERENCES passport_registrations(id) ON DELETE CASCADE,
    CONSTRAINT fk_vote_membership
        FOREIGN KEY (voter_pubkey, group_id, group_provider) 
        REFERENCES memberships(pubkey, group_id, provider),
    -- Ensure one vote per user per poll
    UNIQUE(poll_id, voter_pubkey)
);

-- Create view for poll statistics
CREATE OR REPLACE VIEW poll_stats AS
SELECT 
    p.id as poll_id,
    p.title,
    p.is_show_results_publicly,
    po.id as option_id,
    po.option_text,
    COUNT(pv.id) as vote_count
FROM polls p
LEFT JOIN poll_options po ON po.poll_id = p.id
LEFT JOIN poll_votes pv ON pv.option_id = po.id
GROUP BY p.id, p.title, p.is_show_results_publicly, po.id, po.option_text;

-- Create function to check if poll is still active
CREATE OR REPLACE FUNCTION is_poll_active(poll_id UUID) 
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM polls 
        WHERE id = poll_id 
        AND ends_at > NOW()
    );
END;
$$ LANGUAGE plpgsql;

-- Create trigger to prevent voting on expired polls
CREATE OR REPLACE FUNCTION check_poll_active()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT is_poll_active(NEW.poll_id) THEN
        RAISE EXCEPTION 'Cannot vote on expired poll';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_active_poll_voting
    BEFORE INSERT ON poll_votes
    FOR EACH ROW
    EXECUTE FUNCTION check_poll_active();
-- Enable Row Level Security
-- ALTER DATABASE postgres SET "app.jwt_secret" TO 'your-jwt-secret-here';
-- Drop existing tables if they exist

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
    zk_identity JSONB,
    zk_provider TEXT,   
    zk_identity_expiry TIMESTAMPTZ,
    is_verified BOOLEAN NOT NULL DEFAULT false,
    uuid TEXT,
    nationality TEXT,
    date_of_birth TEXT,
    gender TEXT,
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
    parent_id UUID REFERENCES messages(id) ON DELETE CASCADE,
    reply_count INTEGER NOT NULL DEFAULT 0,
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

-- Create function to update reply count
CREATE OR REPLACE FUNCTION update_reply_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' AND NEW.parent_id IS NOT NULL THEN
        -- When inserting a comment, increment the parent's reply count
        UPDATE messages 
        SET reply_count = reply_count + 1 
        WHERE id = NEW.parent_id;
    ELSIF TG_OP = 'DELETE' AND OLD.parent_id IS NOT NULL THEN
        -- When deleting a comment, decrement the parent's reply count
        UPDATE messages 
        SET reply_count = reply_count - 1 
        WHERE id = OLD.parent_id;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create separate triggers for INSERT and DELETE
CREATE TRIGGER update_reply_count_insert_trigger
    AFTER INSERT ON messages
    FOR EACH ROW
    EXECUTE FUNCTION update_reply_count();

CREATE TRIGGER update_reply_count_delete_trigger
    AFTER DELETE ON messages
    FOR EACH ROW
    EXECUTE FUNCTION update_reply_count();

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_messages_group_id ON messages(group_id);
CREATE INDEX IF NOT EXISTS idx_messages_timestamp ON messages(timestamp);
CREATE INDEX IF NOT EXISTS idx_messages_pubkey ON messages(pubkey);
CREATE INDEX IF NOT EXISTS idx_messages_parent_id ON messages(parent_id);
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

-- Drop existing indexes first
DROP INDEX IF EXISTS idx_passport_registrations_pubkey;
DROP INDEX IF EXISTS idx_passport_registrations_group_id;
DROP INDEX IF EXISTS idx_passport_registrations_provider;
DROP INDEX IF EXISTS idx_ephemeral_keys_pubkey;

-- Drop existing table
DROP TABLE IF EXISTS passport_registrations;
DROP TABLE IF EXISTS ephemeral_keys;

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
CREATE INDEX IF NOT EXISTS idx_ephemeral_keys_pubkey ON ephemeral_keys(pubkey);


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
    group_id TEXT NOT NULL,
    group_provider TEXT NOT NULL,
    internal BOOLEAN NOT NULL DEFAULT false
);

CREATE INDEX IF NOT EXISTS idx_country_messages_nationality ON country_messages(nationality);
CREATE INDEX IF NOT EXISTS idx_country_messages_date_of_birth ON country_messages(date_of_birth);
CREATE INDEX IF NOT EXISTS idx_country_messages_gender ON country_messages(gender);
CREATE INDEX IF NOT EXISTS idx_country_messages_ephemeral_key_id ON country_messages(ephemeral_key_id);
CREATE INDEX IF NOT EXISTS idx_country_messages_passport_registration_id ON country_messages(passport_registration_id);
CREATE INDEX IF NOT EXISTS idx_country_messages_pubkey ON country_messages(pubkey);
CREATE INDEX IF NOT EXISTS idx_country_messages_group_id ON country_messages(group_id);
CREATE INDEX IF NOT EXISTS idx_country_messages_group_provider ON country_messages(group_provider);

-- Add new columns to polls table to match membership attributes
ALTER TABLE memberships
ADD COLUMN zk_identity JSONB,
ADD COLUMN zk_provider TEXT,
ADD COLUMN nationality TEXT,
ADD COLUMN date_of_birth TEXT,
ADD COLUMN gender TEXT,
ADD COLUMN uuid TEXT,
ADD COLUMN is_verified BOOLEAN DEFAULT false;

-- Create polls table
CREATE TABLE IF NOT EXISTS polls (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id TEXT NOT NULL,
    group_provider TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    is_yes_no BOOLEAN NOT NULL DEFAULT false,
    max_options INTEGER NOT NULL DEFAULT 1,
    min_options INTEGER NOT NULL DEFAULT 1,
    answer_options TEXT[] NOT NULL DEFAULT '{}',
    multiselect BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ends_at TIMESTAMPTZ NOT NULL,
    creator_pubkey TEXT NOT NULL,
    is_show_results_publicly BOOLEAN NOT NULL DEFAULT false,
    membership_id UUID REFERENCES memberships(id) ON DELETE CASCADE,
    passport_registration_id UUID REFERENCES passport_registrations(id) ON DELETE CASCADE,
    ephemeral_key_id UUID REFERENCES ephemeral_keys(id) ON DELETE CASCADE,
    is_only_organizations BOOLEAN,
    is_only_kyc_verified BOOLEAN,
    age_required INTEGER,
    is_specific_countries BOOLEAN,
    nationality TEXT,
    date_of_birth TEXT,
    gender TEXT,
    organization_name TEXT,
    pubkey TEXT,
    selected_countries TEXT[],
    selected_organizations TEXT[],
    -- Vote statistics
    total_votes INTEGER DEFAULT 0,
    total_kyc_votes INTEGER DEFAULT 0,
    total_org_votes INTEGER DEFAULT 0
);

-- Create poll options/answers table
CREATE TABLE IF NOT EXISTS poll_options (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    poll_id UUID NOT NULL REFERENCES polls(id) ON DELETE CASCADE,
    option_text TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    vote_count INTEGER DEFAULT 0
);

-- Create poll votes table with one vote per user constraint
CREATE TABLE IF NOT EXISTS poll_votes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    poll_id UUID NOT NULL REFERENCES polls(id) ON DELETE CASCADE,
    option_id UUID REFERENCES poll_options(id) ON DELETE CASCADE,
    voter_pubkey TEXT NOT NULL,
    group_id TEXT NOT NULL,
    group_provider TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_organization_vote BOOLEAN,
    is_kyc_vote BOOLEAN,
    nationality TEXT,
    gender TEXT,
    age TEXT,
    membership_id UUID REFERENCES memberships(id) ON DELETE CASCADE,
    passport_registration_id UUID REFERENCES passport_registrations(id) ON DELETE CASCADE,
    ephemeral_key_id UUID REFERENCES ephemeral_keys(id) ON DELETE CASCADE,
    -- Ensure one vote per user per poll
    UNIQUE(poll_id, voter_pubkey)
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_poll_votes_poll_id ON poll_votes(poll_id);
CREATE INDEX IF NOT EXISTS idx_poll_votes_option_id ON poll_votes(option_id);
CREATE INDEX IF NOT EXISTS idx_poll_votes_voter_pubkey ON poll_votes(voter_pubkey);
CREATE INDEX IF NOT EXISTS idx_poll_options_poll_id ON poll_options(poll_id);

-- Function to update vote counts
CREATE OR REPLACE FUNCTION update_vote_counts()
RETURNS TRIGGER AS $$
BEGIN
    -- Update option vote count
    UPDATE poll_options 
    SET vote_count = (
        SELECT COUNT(*) 
        FROM poll_votes 
        WHERE option_id = NEW.option_id
    )
    WHERE id = NEW.option_id;

    -- Update poll total votes
    UPDATE polls 
    SET 
        total_votes = (
            SELECT COUNT(*) 
            FROM poll_votes 
            WHERE poll_id = NEW.poll_id
        ),
        total_kyc_votes = (
            SELECT COUNT(*) 
            FROM poll_votes 
            WHERE poll_id = NEW.poll_id AND is_kyc_vote = true
        ),
        total_org_votes = (
            SELECT COUNT(*) 
            FROM poll_votes 
            WHERE poll_id = NEW.poll_id AND is_organization_vote = true
        )
    WHERE id = NEW.poll_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for vote count updates
CREATE TRIGGER update_vote_counts_trigger
    AFTER INSERT OR DELETE ON poll_votes
    FOR EACH ROW
    EXECUTE FUNCTION update_vote_counts();

-- Enhanced view for poll statistics
CREATE OR REPLACE VIEW poll_stats AS
SELECT 
    p.id as poll_id,
    p.title,
    p.is_show_results_publicly,
    p.total_votes,
    p.total_kyc_votes,
    p.total_org_votes,
    po.id as option_id,
    po.option_text,
    po.vote_count,
    COUNT(CASE WHEN pv.is_kyc_vote = true THEN 1 END) as kyc_vote_count,
    COUNT(CASE WHEN pv.is_organization_vote = true THEN 1 END) as org_vote_count,
    (
        SELECT jsonb_object_agg(
            COALESCE(nationality, 'unknown'),
            count
        )
        FROM (
            SELECT nationality, COUNT(*) as count
            FROM poll_votes
            WHERE poll_id = p.id
            GROUP BY nationality
        ) nationality_counts
    ) as votes_by_country
FROM polls p
LEFT JOIN poll_options po ON po.poll_id = p.id
LEFT JOIN poll_votes pv ON pv.option_id = po.id
GROUP BY p.id, p.title, p.is_show_results_publicly, p.total_votes, p.total_kyc_votes, p.total_org_votes, po.id, po.option_text, po.vote_count;

-- Create function to check if poll is still active
CREATE OR REPLACE FUNCTION is_poll_active(poll_id UUID) 
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM polls 
        WHERE id = poll_id 
        AND ends_at > NOW()
    );
END;
$$ LANGUAGE plpgsql;

-- Create trigger to prevent voting on expired polls
CREATE OR REPLACE FUNCTION check_poll_active()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT is_poll_active(NEW.poll_id) THEN
        RAISE EXCEPTION 'Cannot vote on expired poll';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_active_poll_voting
    BEFORE INSERT ON poll_votes
    FOR EACH ROW
    EXECUTE FUNCTION check_poll_active();
