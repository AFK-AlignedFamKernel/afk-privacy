import React, { useState } from 'react';
import IonIcon from "@reacticons/ionicons";
import { SignedMessageWithProof, SignedMessage } from "../../lib/types";
import { signMessageSelfXyz } from "../../lib/zk-did";

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
  title?: string;
  description?: string;
  about?: string;
};

type ReviewCardProps = {
  review: Review;
  isInternal?: boolean;
  onVote?: (pollId: string, option: string) => Promise<void>;
  handleOnVote?: () => Promise<void>;
};

const PollCard: React.FC<ReviewCardProps> = ({ review, isInternal, onVote }) => {
  const [selectedOptions, setSelectedOptions] = useState<Set<string>>(new Set());
  const [error, setError] = useState<string | null>(null);
  const [isVoting, setIsVoting] = useState(false);

  const handleOnVote = async (pollId: string, option: string) => {
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

      // setSelectedPoll(pollId);
      // // Refresh polls to show updated results
      // fetchPolls();
    } catch (error) {
      console.error('Error voting:', error);
      // Show error message to user
      setError((error as Error).message);
    }
  };


  const getAnonymousName = () => {
    if (!review.ephemeralPubkey) return 'Anonymous';
    const pubkeyStr = review.ephemeralPubkey.toString();
    return `Anonymous User ${pubkeyStr.slice(0, 6)}`;
  };

  const renderRating = () => {
    if (!review.metadata?.rating) return null;
    const rating = review.metadata.rating;
    
    return (
      <div className="review-rating">
        {[...Array(5)].map((_, i) => (
          <IonIcon
            key={i}
            name={i < rating ? "star" : "star-outline"}
            className="rating-star"
          />
        ))}
      </div>
    );
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
    // if (!onVote || !review.id) return;
    if (!review.id) return;
    
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
      <div className="poll-options">
        {review.answer_options.map((option, index) => (
          <div key={index} className="poll-option">
            <input 
              type={review.multiselect ? "checkbox" : "radio"}
              name={`poll-${review.id}`}
              id={`option-${review.id}-${index}`}
              checked={selectedOptions.has(option)}
              onChange={() => handleOptionSelect(option)}
              disabled={isVoting}
            />
            <label htmlFor={`option-${review.id}-${index}`}>{option}</label>
          </div>
        ))}
        <button 
          className="submit-vote-button"
          onClick={handleSubmitVote}
          disabled={isVoting || selectedOptions.size === 0}
        >
          {isVoting ? "Submitting..." : "Submit Vote"}
        </button>
      </div>
    );
  };

  const renderPollRequirements = () => {
    const requirements = [];
    if (review.is_only_kyc_verified) {
      requirements.push("KYC Verified Users Only");
    }
    if (review.is_only_organizations) {
      requirements.push("Organizations Only");
    }
    if (requirements.length === 0) return null;

    return (
      <div className="poll-requirements">
        <small>Requirements: {requirements.join(", ")}</small>
      </div>
    );
  };

  return (
    <div className="review-card">
      <header className="review-card-header">
        <div className="review-card-header-sender">
          <span className="review-author">
            {getAnonymousName()}
          </span>
          <span className="review-timestamp">
            {new Date(review.timestamp).toLocaleDateString()}
          </span>
        </div>
      </header>

      <main className="review-card-content">
        <div className="review-text">{review.title}</div>
        {renderRating()}
        {renderPollOptions()}
        {renderPollRequirements()}
        {error && <div className="error-message">{error}</div>}
      </main>

      <div className="review-card-footer">
        <div className="like-button-container">
          <button className="like-button">
            <IonIcon name="heart-outline" />
            <span className="like-count">{review.likes || 0}</span>
          </button>
        </div>
      </div>
    </div>
  );
};

export default PollCard; 