import React, { useState } from 'react';
import IonIcon from "@reacticons/ionicons";
import { SignedMessageWithProof, SignedMessage } from "../../lib/types";
import { signMessageSelfXyz } from "../../lib/zk-did";
import { countryNames, domainNames } from "../../lib/constants";

type ReviewMetadata = {
  rating?: number;
};

type Review = SignedMessageWithProof & {
  metadata?: ReviewMetadata;
  is_yes_no?: boolean;
  answer_options?: string[];
  max_options?: number;
  min_options?: number;
  multiselect?: boolean;
  ends_at?: Date;
  show_results_publicly?: boolean;
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

type ReviewCardProps = {
  review: Review;
  isInternal?: boolean;
  onVote?: (pollId: string, option: string) => Promise<void>;
};

const PollCard: React.FC<ReviewCardProps> = ({ review, isInternal, onVote }) => {
  const [selectedOptions, setSelectedOptions] = useState<Set<string>>(new Set());
  const [error, setError] = useState<string | null>(null);
  const [isVoting, setIsVoting] = useState(false);
  const [isExpanded, setIsExpanded] = useState(false);

  const handleOnVote = async (pollId: string, option: string, options?: string) => {
    console.log("handleOnVote")
    try {
      // Create a signed message for the vote
      const message = {
        id: crypto.randomUUID(),
        text: `Vote for ${option} in poll ${pollId}`,
        timestamp: new Date(),
        internal: false,
        anonGroupId: 'self-xyz',
        anonGroupProvider: 'self-xyz',
        likes: 0,
        replyCount: 0,
        parentId: null,
      };

      const { signature, ephemeralPubkey, ephemeralPubkeyExpiry } = await signMessageSelfXyz(message);

      const signedMessage: SignedMessage = {
        ...message,
        signature,
        ephemeralPubkey,
        ephemeralPubkeyExpiry,
      };

      const response = await fetch('/api/poll/vote', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          pollId,
          option,
          signedMessage: {
            ...signedMessage,
            pubkey: signedMessage.ephemeralPubkey.toString(),
            ephemeralPubkey: signedMessage.ephemeralPubkey.toString(),
            signature: signedMessage.signature.toString(),
          },
        }),
      });

      if (!response.ok) {
        const error = await response.json();
        throw new Error(error.error || 'Failed to vote');
      }

      // Refresh polls to show updated results
      window.location.reload();
    } catch (error) {
      console.error('Error voting:', error);
      setError((error as Error).message);
    }
  };

  const getAnonymousName = () => {
    if (!review.ephemeralPubkey) return 'Anonymous';
    const pubkeyStr = review.ephemeralPubkey.toString();
    return `Anonymous User ${pubkeyStr.slice(0, 6)}`;
  };

  const handleOptionSelect = (option: string) => {
    if (!review.multiselect) {
      setSelectedOptions(new Set([option]));
      return;
    }

    const newSelected = new Set(selectedOptions);
    if (newSelected.has(option)) {
      newSelected.delete(option);
    } else {
      if (newSelected.size >= (review.max_options || 1)) {
        setError(`You can select at most ${review.max_options} options`);
        return;
      }
      newSelected.add(option);
    }
    setSelectedOptions(newSelected);
    setError(null);
  };

  const handleSubmitVote = async () => {
    console.log("handleSubmitVote",);
    console.log("handleSubmitVote", review);
    // if (!review.id) return;

    if (selectedOptions.size === 0) {
      setError("Please select at least one option");
      return;
    }

    // if (review.min_options && selectedOptions.size < review.min_options) {
    //   setError(`Please select at least ${review.min_options} options`);
    //   return;
    // }

    try {
      setIsVoting(true);
      setError(null);

      // For multiple selections, submit each vote
      for (const option of selectedOptions) {
        console.log("handleOnVote", option);
        await handleOnVote(review.id, option);
      }
    } catch (err) {
      setError((err as Error).message);
    } finally {
      setIsVoting(false);
    }
  };

  const renderPollOptions = () => {
    if (!review.answer_options?.length) return null;

    return (
      <div className="poll-options-container">
        <div className="poll-options">
          {review.answer_options.map((option, index) => (
            <div key={index} className="poll-option">
              <input
                type={review.multiselect ? "checkbox" : "radio"}
                name={`poll-${review.id}`}
                id={`option-${review.id}-${index}`}
                checked={selectedOptions.has(option)}
                onChange={() => handleOptionSelect(option)}
                disabled={isVoting || review.has_voted}
              />
              <label htmlFor={`option-${review.id}-${index}`}>
                {option}
                {review.show_results_publicly && review.option_votes && (
                  <span className="option-vote-count">
                    ({review.option_votes[option] || 0})
                  </span>
                )}
              </label>
            </div>
          ))}

        </div>
        <button
          className="submit-vote-button"
          onClick={handleSubmitVote}
          disabled={isVoting || selectedOptions.size === 0 || review.has_voted}
        >
          {review.has_voted ? "Already Voted" : isVoting ? "Submitting..." : "Submit Vote"}
        </button>
      </div>

    );
  };

  const renderPollRequirements = () => {
    console.log("review", review);
    const requirements = [];

    if (review?.selected_countries?.length) {
      requirements.push(`Countries: ${review.selected_countries?.length ? review.selected_countries.map(code => countryNames[code] || code).join(", ") : 'All'}`);
    }
    // if (review.is_specific_countries) {
    //   requirements.push(`Countries: ${review.countries_accepted?.length ? review.countries_accepted.map(code => countryNames[code] || code).join(", ") : 'All'}`);
    // }

    if (review?.selected_organizations?.length) {
      requirements.push(`Organizations: ${review.selected_organizations?.length ? review.selected_organizations.map(code => domainNames[code] || code).join(", ") : 'All'}`);
    }


    if (review.is_only_kyc_verified) {
      requirements.push("KYC Verified Users Only");
    }
    if (review.is_only_organizations) {
      requirements.push("Organizations Only");
    }
    if (review.age_required) {
      requirements.push(`Age ${review.age_required}+`);
    }
    if (review.is_specific_countries) {
      if (review.countries_accepted?.length) {
        const countryNamesList = review.countries_accepted
          .map(code => countryNames[code] || code)
          .join(", ");
        requirements.push(`Countries: ${countryNamesList}`);
      }
      if (review.countries_excluded?.length) {
        const excludedCountries = review.countries_excluded
          .map(code => countryNames[code] || code)
          .join(", ");
        requirements.push(`Excluded: ${excludedCountries}`);
      }
    }
    if (review.nationality) {
      requirements.push(`Nationality: ${review.nationality}`);
    }
    if (review.gender) {
      requirements.push(`Gender: ${review.gender}`);
    }
    if (review.organization_name) {
      requirements.push(`Organization: ${review.organization_name}`);
    }
    if (review.selected_organizations?.length) {
      const orgNames = review.selected_organizations
        .map(domain => domainNames[domain] || domain)
        .join(", ");
      requirements.push(`Selected Organizations: ${orgNames}`);
    }


    // if (requirements.length === 0) return null;

    return (
      <div className="poll-requirements">
        <h4>Requirements</h4>
        <ul>
          {requirements.map((req, index) => (
            <li key={index}>
              <IonIcon name="checkmark-circle-outline" />
              <span>{req}</span>
            </li>
          ))}
        </ul>
      </div>
    );
  };

  const renderPollStats = () => {
    if (!review.show_results_publicly) return null;

    const totalVotes = review.total_votes || 0;
    const optionVotes = review.option_votes || {};

    return (
      <div className="poll-stats">
        <div className="poll-stats-header">
          <h4>Poll Results</h4>
          <span className="total-votes">{totalVotes} {totalVotes === 1 ? 'vote' : 'votes'}</span>
        </div>

        <div className="poll-stats-options">
          {review.answer_options?.map((option, index) => {
            const votes = optionVotes[option] || 0;
            const percentage = totalVotes > 0 ? (votes / totalVotes) * 100 : 0;

            return (
              <div key={index} className="poll-stats-option">
                <div className="poll-stats-option-header">
                  <span className="option-text">{option}</span>
                  <span className="option-votes">{votes} votes ({percentage.toFixed(1)}%)</span>
                </div>
                <div className="poll-stats-bar">
                  <div
                    className="poll-stats-fill"
                    style={{ width: `${percentage}%` }}
                  />
                </div>
              </div>
            );
          })}
        </div>
      </div>
    );
  };

  const renderPollOverview = () => {

    const totalVotes = review.total_votes || 0;
    const optionVotes = review.option_votes || {};


    return (
      <div className="poll-voting-stats">

        <div className="poll-stats">
          <div className="stat-item total-votes">
            <IonIcon name="bar-chart-outline" />
            <span>{review.total_votes || 0} votes</span>
          </div>
          <div className="stat-item">
            <IonIcon name={review.multiselect ? "checkbox-outline" : "radio-button-on-outline"} />
            <span>{review.multiselect ? "Multiple choice" : "Single choice"}</span>
          </div>
          <div className="stat-item">
            <IonIcon name="time-outline" />
            <span>Ends: {new Date(review.ends_at!).toLocaleString()}</span>
          </div>
        </div>
      </div>
    )

  }



  return (
    <div className="poll-card">
      <div className="poll-header-container">
        <div className="poll-header">
          <div className="poll-title-section">
            <h3 className="poll-title">{review.title}</h3>
            <h4 className="poll-subtitle">{review.description}</h4>
            <div className="poll-meta">
              <div className="poll-author">
                <IonIcon name="person-outline" />
                <span>{getAnonymousName()}</span>
              </div>
              <div className="poll-date">
                <IonIcon name="time-outline" />
                <span>{review?.created_at ? new Date(review?.created_at).toLocaleDateString() : ''}</span>
              </div>
              <div className="poll-date">
                <IonIcon name="time-outline" />
                <span>Ends: {new Date(review.ends_at!).toLocaleString()}</span>
              </div>
              <div className="stat-item total-votes">
                <IonIcon name="bar-chart-outline" />
                <span>{review.total_votes || 0} votes</span>
              </div>
            </div>
          </div>
          <div className="poll-actions">
            <button
              className={`expand-button ${isExpanded ? 'expanded' : ''}`}
              onClick={() => setIsExpanded(!isExpanded)}
            >
              <IonIcon name="chevron-down-outline" />
              <span>{isExpanded ? 'Show Less' : 'Show More'}</span>
            </button>
          </div>

        </div>
        {renderPollRequirements()}


      </div>



      {/* <div className={`poll-details ${isExpanded ? 'expanded' : ''}`}> */}
      {/* <div className={`poll-details`}> */}
      {/* <div className="details-content">
        {renderPollRequirements()}
        {renderPollStats()}
      </div> */}
      {/* </div> */}
      {/* {renderPollOverview()} */}

      {isExpanded &&

        <>
          <div className="details-content">
            {renderPollOverview()}

            {renderPollStats()}
          </div>

        </>}



      <div className="poll-content">
        {review.description && (
          <p className="poll-description">{review.description}</p>
        )}
        {renderPollOptions()}
        {error && <div className="error-message">{error}</div>}

      </div>



    </div>
  );
};

export default PollCard; 