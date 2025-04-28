/**
 * Represents an anonymous group where members can post messages without revealing their identity
 * Example: people in a company
 */
export interface AnonGroup {
  /** Unique identifier for the group (e.g: company domain) */
  id: string;
  /** Display name of the group */
  title: string;
  /** URL to the group's logo image */
  logoUrl: string;
}

/**
 * Ephemeral key pair generated and stored in the browser's local storage
 * This key is used to sign messages.
 */
export interface EphemeralKey {
  privateKey: bigint;
  publicKey: bigint;
  salt: bigint;
  expiry: Date;
  ephemeralPubkeyHash: bigint;
}

/**
 * Provider interface for generating and verifying ZK proofs of AnonGroup membership
 * Example: Google, Slack (for "people in a company")
 */
export interface AnonGroupProvider {
  /** Get the provider's unique identifier */
  name(): string;

  /** Slug is a key that represents the type of the AnonGroup identifier (to be used in URLs). Example: "domain" */
  getSlug(): string;

  /**
   * Generate a ZK proof that the current user is a member of an AnonGroup
   * @param ephemeralPubkeyHash - Hash of the ephemeral pubkey, expiry and salt
   * @returns Returns the AnonGroup and membership proof, along with additional args that may be needed for verification
   */
  generateProof(ephemeralKey: EphemeralKey): Promise<{
    proof: Uint8Array;
    anonGroup: AnonGroup;
    proofArgs: object;
  }>;

  /**
   * Verify a ZK proof of group membership
   * @param proof - The ZK proof to verify
   * @param ephemeralPubkey - Pubkey modulus of the ephemeral key that was used when generating the proof
   * @param anonGroup - AnonGroup that the proof claims membership in
   * @param proofArgs - Additional args that was returned when the proof was generated
   * @returns Promise resolving to true if the proof is valid
   */
  verifyProof(
    proof: Uint8Array,
    anonGroupId: string,
    ephemeralPubkey: bigint,
    ephemeralPubkeyExpiry: Date,
    proofArgs: object
  ): Promise<boolean>;

  /**
   * Get the AnonGroup by its unique identifier
   * @param groupId - Unique identifier for the AnonGroup
   * @returns Promise resolving to the AnonGroup
   */
  getAnonGroup(groupId: string): AnonGroup;
}

/**
 * Represents a message posted by an AnonGroup member
 */
export interface Message {
  /** Unique identifier for the message */
  id: string;
  /** ID of the AnonGroup the corresponding user belongs to */
  anonGroupId: string;
  /** Name of the provider that generated the proof that the user (user's ephemeral pubkey) belongs to the AnonGroup */
  anonGroupProvider: string;
  /** Content of the message */
  text: string;
  /** Unix timestamp when the message was created */
  timestamp: Date;
  /** Whether this message is only visible to other members of the same AnonGroup */
  internal: boolean;
  /** Number of likes message received */
  likes: number;
  /** Number of replies to the message */
  replyCount?: number;
  /** ID of the parent message (if this message is a reply) */
  parentId?: string | null;
}

export interface SignedMessage extends Message {
  /** Ed25519 signature of the message - signed by the user's ephemeral private key (in hex format) */
  signature: bigint;
  /** Ed25519 pubkey that can verify the signature */
  ephemeralPubkey: bigint;
  /** Expiry of the ephemeral pubkey */
  ephemeralPubkeyExpiry: Date;
}

export interface SignedMessageWithProof extends SignedMessage {
  /** ZK proof that the sender belongs to the AnonGroup */
  proof: Uint8Array;
  /** Additional args that was returned when the proof was generated */
  proofArgs: object;
  /** Proof in string format */
  proofString?: string;
  /** Proof args in string format */
  proofArgsString?: string;
}

export const LocalStorageKeys = {
  EphemeralKey: "ephemeralKey",
  CurrentGroupId: "currentGroupId",
  CurrentCountryId: "currentCountryId",
  CurrentProvider: "currentProvider",
  GoogleOAuthState: "googleOAuthState",
  GoogleOAuthNonce: "googleOAuthNonce",
  DarkMode: "darkMode",
  HasSeenWelcomeMessage: "hasSeenWelcomeMessage",
  EphemeralKeyPassportRegistration: "ephemeralKeyPassportRegistration",
  SelfKeyPassportRegistration: "selfKeyPassportRegistration",
  CurrentKYCProvider: "currentKYCProvider",
  PassportVerified: "passportVerified",

};

export interface PassportRegistration {
  id_register?: string;
  nationality?: string;
  date_of_birth?: string;
  gender?: string;
  is_verified?: boolean;
  proof_args?: string;
}

export interface SignedMessageWithProofWithPassport extends PassportRegistration, SignedMessageWithProof {

}

export interface PollStats {
  id: string,
  title: string,
  total_votes: number,
  total_kyc_votes: number,
  total_org_votes: number,
  options: Array<{
    id: string,
    option_text: string,
    vote_count: number,
    kyc_votes: number,
    org_votes: number
  }>,
  votes_by_country: {
    [country: string]: number
  },
  votes_by_gender: {
    [gender: string]: number
  }
}

export type ReviewMetadata = {
  rating?: number;
};

export type Review = SignedMessageWithProof & {
  metadata?: ReviewMetadata;
  is_yes_no?: boolean;
  answer_options?: string[];
  max_options?: number;
  min_options?: number;
  multiselect?: boolean;
  ends_at?: Date;
  is_show_results_publicly?: boolean;
  is_only_organizations?: boolean;
  is_only_kyc_verified?: boolean;
  age_required?: number;
  is_specific_countries?: boolean;
  countries_accepted?: string[];
  countries_excluded?: string[];
  nationality?: string;
  date_of_birth?: string;
  gender?: string;
  organization_name?: string;
  title?: string;
  description?: string;
  total_votes?: number;
  option_votes?: Record<string, number>;
  has_voted?: boolean;
  selected_organizations?: string[];
  internal?: boolean;
  created_at?: Date;
  selected_countries?: string[];
};