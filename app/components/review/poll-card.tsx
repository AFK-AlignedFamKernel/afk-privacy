import React, { useState, useEffect } from 'react';
import IonIcon from "@reacticons/ionicons";
import { SignedMessageWithProof, SignedMessage, Message, PollStats } from "../../lib/types";
import { signMessageSelfXyz } from "../../lib/zk-did";
import { countryNames, domainNames } from "../../lib/constants";
import Link from 'next/link';
import COUNTRY_DATA from '@/assets/country';
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
  const [isExpandedDescription, setIsExpandedDescription] = useState(false);
  const [isShowStats, setIsShowStats] = useState(false);

  const [statsData, setStatsData] = useState<any | PollStats | undefined>(undefined);

  const [isLoadingStats, setIsLoadingStats] = useState(false);

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

      if (!signature || !ephemeralPubkey || !ephemeralPubkeyExpiry) {
        throw new Error("Failed to sign message");
      }

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

      // TODO
      // Refresh polls to show updated results
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
        // console.log("handleOnVote", option);
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
                {review.is_show_results_publicly && review.option_votes && (
                  <span className="option-vote-count">
                    ({review.option_votes[option] || 0})
                  </span>
                )}
              </label>
            </div>
          ))}

        </div>


        <div>

          <button
            className="submit-vote-button"
            onClick={handleSubmitVote}
            disabled={isVoting || selectedOptions.size === 0 || review.has_voted}
          >
            {review.has_voted ? "Already Voted" : isVoting ? "Submitting..." : "Submit Vote"}
          </button>

        </div>

      </div>

    );
  };


  const handleSignMessage = async () => {
    try {
      const message: Message = {
        id: crypto.randomUUID(),
        text: review.title ?? `View poll results for ${review.id}`,
        timestamp: new Date(),
        internal: false,
        anonGroupId: 'self-xyz',
        anonGroupProvider: 'self-xyz',
        likes: 0,
        replyCount: 0,
        parentId: null,
      };

      const { signature, ephemeralPubkey, ephemeralPubkeyExpiry } = await signMessageSelfXyz(message);

      if (!signature || !ephemeralPubkey || !ephemeralPubkeyExpiry) {
        throw new Error("Failed to sign message");
      }

      const signedMessageFormatted = {
        ...message,
        signature,
        ephemeralPubkey,
        ephemeralPubkeyExpiry,
      };
      return signedMessageFormatted;
    } catch (error) {
      console.error("Error signing message", error);
      return null;
    }
  }

  useEffect(() => {


    if (review.is_show_results_publicly) {
      handleResultStats();
      setIsShowStats(true);
    }
  }, [review.is_show_results_publicly]);


  const handleResultStats = async () => {

    try {
      // console.log("handleResultStats", review);
      const signedMessage = await handleSignMessage();
      // console.log("signedMessage", signedMessage);

      if (!signedMessage) return;

      const signedMessageFormatted = {
        ...signedMessage,
        ephemeralPubkey: signedMessage.ephemeralPubkey.toString(),
        signature: signedMessage.signature.toString(),
      };

      const res = await fetch('/api/poll/result-vote', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ pollId: review.id, option: selectedOptions.values().next().value, signedMessage: signedMessageFormatted }),
      });
      // console.log("res", res);

      const data = await res.json();
      // console.log("data", data);
      setStatsData(data);
    } catch (error) {
      console.error("Error fetching result stats", error);
    }

  }

  const renderPollRequirements = () => {
    // console.log("review", review);
    const requirements = [];

    if (review?.selected_countries?.length) {
      // console.log("review.selected_countries", review.selected_countries);
      const countryFlags = review.selected_countries.map(code => COUNTRY_DATA[code?.toUpperCase()]?.flag ?? "");
      // console.log("countryFlags", countryFlags);
      requirements.push(`Countries: ${review.selected_countries?.length ? review.selected_countries.map(code => `${COUNTRY_DATA[code?.toUpperCase()]?.name || code} ${COUNTRY_DATA[code?.toUpperCase()]?.flag ?? ""}`).join(", ") : 'All'}`);
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


    if (requirements.length === 0) return null;

    return (
      <div className="poll-requirements">
        <p>Requirements</p>
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

    if (!review.is_show_results_publicly) return null;

    const totalVotes = statsData?.total_votes || 0;
    const optionVotes = statsData?.options || [];
    // console.log("optionVotes", optionVotes);
    // console.log("renderPollStats", review);
    // console.log("statsData", statsData);
    
    return (
      <div className="poll-stats">
        <div className="poll-stats-header">
          <h4>Poll Results</h4>
          <span className="bar-chart-outline total-votes">
            <IonIcon name="bar-chart-outline" />
            {totalVotes} {totalVotes === 1 ? 'vote' : 'votes'}</span>
        </div>
        {/* <div className="stat-item total-votes">
          <IonIcon name="bar-chart-outline" />
          <span>{review.total_votes || 0} votes</span>
        </div> */}

        <div className="poll-stats-options">
          {review.answer_options?.map((option, index) => {
            const votes = optionVotes[index]?.vote_count || 0;
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
          {/* <div className="stat-item total-votes">
            <IonIcon name="bar-chart-outline" />
            <span>{review.total_votes || 0} votes</span>
          </div> */}
          <div className="stat-item">
            <IonIcon name={review.multiselect ? "checkbox-outline" : "radio-button-on-outline"} />
            <span>{review.multiselect ? "Multiple choice" : "Single choice"}</span>
          </div>
          {/* <div className="stat-item">
            <IonIcon name="time-outline" />
            <span>Ends: {new Date(review.ends_at!).toLocaleString()}</span>
          </div> */}
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
            {/* <h4 className="poll-subtitle">{review.description}</h4> */}
            <div className="poll-meta poll-author">
              <IonIcon name="person-outline" />
              <span>{getAnonymousName()}</span>
            </div>
            <div className="poll-meta">

              <div className="poll-date">
                <IonIcon name="time-outline" />
                <span>{review?.created_at ? new Date(review?.created_at).toLocaleDateString() : ''}</span>
              </div>
              <div className="poll-date">
                <IonIcon name="time-outline" />
                <span>Ends: {new Date(review.ends_at!).toLocaleString()}</span>
              </div>

              {/* <div className="stat-item">
                <IonIcon name={review.multiselect ? "checkbox-outline" : "radio-button-on-outline"} />
                <span>{review.multiselect ? "Multiple choice" : "Single choice"}</span>
              </div> */}
              {/* <div className="stat-item total-votes">
                <IonIcon name="bar-chart-outline" />
                <span>{review.total_votes || 0} votes</span>
              </div> */}
            </div>

            {/* <div className="poll-stats-container" style={{ gap: "10px", display: "flex", alignItems: "flex-start" }}>
              <div className="poll-date">
                <IonIcon name="eye-outline" />
                <span>{review?.is_show_results_publicly ? "Public" : "Private"}</span>
              </div>

              <div className="poll-select-type">
                <IonIcon name={review.multiselect ? "checkbox-outline" : "radio-button-on-outline"} />
                <span>{review.multiselect ? "Multiple choice" : "Single choice"}</span>
              </div>

            </div> */}

          </div>
          {/* <div className="poll-actions">

            <div className="poll-meta poll-author">
              <IonIcon name="person-outline" />
              <span>{getAnonymousName()}</span>
            </div> <button
              className={`expand-button ${isExpanded ? 'expanded' : ''}`}
              onClick={() => setIsExpanded(!isExpanded)}
            >
              <IonIcon name="chevron-down-outline" />
              <span>{isExpanded ? 'Show Less' : 'Show More'}</span>
            </button>
          </div> */}

        </div>

        <div className="poll-stats-container">

          <p>Details</p>
          <div className="poll-stats-container" style={{ gap: "10px", display: "flex", alignItems: "flex-start", borderRadius: "8px", backgroundColor: "var(--background-secondary)", paddingTop: "10px", paddingBottom: "10px", }}>
            <div className="poll-date">
              <IonIcon name="eye-outline" />
              <span>{review?.is_show_results_publicly ? "Public" : "Private"}</span>
            </div>

            <div className="poll-select-type">
              <IonIcon name={review.multiselect ? "checkbox-outline" : "radio-button-on-outline"} />
              <span>{review.multiselect ? "Multiple choice" : "Single choice"}</span>
            </div>

          </div>
        </div>


        {renderPollRequirements()}

        <button
          className={`expand-button ${isExpanded ? 'expanded' : ''}`}
          onClick={() => {
            setIsExpanded(!isExpanded)
            handleResultStats();
            // setIsShowStats(false)
          }}
        >
          <IonIcon name="chevron-down-outline" />
          <span>{isExpanded ? 'Hide results' : 'Show results'}</span>
        </button>
      </div>



      {/* <div className={`poll-details ${isExpanded ? 'expanded' : ''}`}> */}
      {/* <div className={`poll-details`}> */}
      {/* <div className="details-content">
        {renderPollRequirements()}
        {renderPollStats()}
      </div> */}
      {/* </div> */}
      {/* {renderPollOverview()} */}

      {
        isExpanded &&

        <>
          <div className="details-content">
            {/* {renderPollOverview()} */}

            {renderPollStats()}
          </div>

        </>
      }



      <div className="poll-content">
        {review.description && (
          <>
            <button
              className={`expand-button ${isExpandedDescription ? 'expanded' : ''}`}
              onClick={() => {
                setIsExpandedDescription(!isExpandedDescription)
              }}
            >
              <p className="poll-description">
                {review.description.length > 30 && !isExpandedDescription
                  ? `${review.description.slice(0, 30)}...`
                  : review.description
                }
              </p>

              {review?.description?.length > 30 && !isExpandedDescription && (
                <IonIcon name="chevron-down-outline" />
              )}
            </button>
          </>

        )}
        {renderPollOptions()}
        {error && <div className="error-message">{error}</div>}

      </div>

      <div>

        <button
          className={`expand-button ${isExpanded ? 'expanded' : ''}`}
          onClick={() => {
            setIsExpanded(!isExpanded)
            handleResultStats();
            // setIsShowStats(false)
          }}
        >
          <IonIcon name="chevron-down-outline" />
          <span>{isExpanded ? 'Hide results' : 'Show results'}</span>
        </button>
      </div>


      <div style={{ display: "flex", justifyContent: "center", alignItems: "center", marginTop: "2  0px" }}>
        <p
          className="submit-vote-button"
        >
          <IonIcon name="open-outline" />
          <Link href={`/poll/${review.id}`}>View poll</Link>
        </p>
      </div>

    </div >
  );
};

export default PollCard; 