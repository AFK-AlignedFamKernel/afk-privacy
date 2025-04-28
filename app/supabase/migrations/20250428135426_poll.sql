-- Drop existing objects in correct order
DROP VIEW IF EXISTS poll_stats;
DROP TRIGGER IF EXISTS enforce_active_poll_voting ON poll_votes;
DROP TRIGGER IF EXISTS update_vote_counts_trigger ON poll_votes;
DROP FUNCTION IF EXISTS check_poll_active();
DROP FUNCTION IF EXISTS is_poll_active(UUID);
DROP FUNCTION IF EXISTS update_vote_counts();
DROP TABLE IF EXISTS poll_votes;
DROP TABLE IF EXISTS poll_options;
DROP TABLE IF EXISTS polls;

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
