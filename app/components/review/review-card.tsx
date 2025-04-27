import React from 'react';
import IonIcon from "@reacticons/ionicons";
import { SignedMessageWithProof } from "../../lib/types";

type ReviewMetadata = {
  rating?: number;
};

type Review = SignedMessageWithProof & {
  metadata?: ReviewMetadata;
};

type ReviewCardProps = {
  review: Review;
  isInternal?: boolean;
};

const ReviewCard: React.FC<ReviewCardProps> = ({ review, isInternal }) => {
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
        <div className="review-text">{review.text}</div>
        {renderRating()}
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

export default ReviewCard; 