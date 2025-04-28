export interface CountryVote {
    nationality: string | null;
    count: number;
  }

export interface PollOption {
    id: string;
    option_text: string;
    vote_count: number;
    poll_votes: Array<{
      is_kyc_vote: boolean;
      is_organization_vote: boolean;
    }>;
  }

export interface PollStats {
    id: string;
    title: string;
    total_votes: number;
    total_kyc_votes: number;
    total_org_votes: number;
    options: PollOption[];
    votes_by_country: Record<string, number>;
    total_poll_votes: number;
  }