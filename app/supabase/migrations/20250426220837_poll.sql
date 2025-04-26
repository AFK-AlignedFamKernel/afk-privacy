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
    multiselect BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ends_at TIMESTAMPTZ NOT NULL,
    creator_pubkey TEXT NOT NULL,
    show_results_publicly BOOLEAN NOT NULL DEFAULT false,
    membership_id UUID REFERENCES memberships(id) ON DELETE CASCADE,
    is_only_organizations BOOLEAN,
    is_only_kyc_verified BOOLEAN,
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
    p.show_results_publicly,
    po.id as option_id,
    po.option_text,
    COUNT(pv.id) as vote_count
FROM polls p
LEFT JOIN poll_options po ON po.poll_id = p.id
LEFT JOIN poll_votes pv ON pv.option_id = po.id
GROUP BY p.id, p.title, p.show_results_publicly, po.id, po.option_text;

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


-- Add new columns to polls table to match membership attributes
ALTER TABLE memberships
ADD COLUMN zk_identity JSONB,
ADD COLUMN zk_provider TEXT,
ADD COLUMN nationality TEXT,
ADD COLUMN date_of_birth TEXT,
ADD COLUMN gender TEXT,
ADD COLUMN uuid TEXT,
ADD COLUMN is_verified BOOLEAN DEFAULT false;
