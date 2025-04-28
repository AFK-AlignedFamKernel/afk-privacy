"use client";

import React, { useState, useEffect, useRef, useCallback } from "react";
import Link from "next/link";
import { fetchMessagesCountry, getMyDataMessageCountry } from "../../lib/country/index";
import { signMessageSelfXyz } from "../../lib/zk-did";
import { Message, SignedMessageWithProof, SignedMessage } from "../../lib/types";
import ReviewPollForm from "./review-poll-form";
import ReviewCard from "./poll-card";
import Dialog from "../dialog";
import PollCard from "./poll-card";
import CryptoLoading from "../small/crypto-loading";

const MESSAGES_PER_PAGE = 30;
const INITIAL_POLL_INTERVAL = 10000; // 10 seconds
const MAX_POLL_INTERVAL = 100000; // 100 seconds

type ReviewListProps = {
  isInternal?: boolean;
  groupId?: string;
  showMessageForm?: boolean;
};

const ReviewList: React.FC<ReviewListProps> = ({
  isInternal,
  groupId,
  showMessageForm = false,
}) => {
  // State
  const [reviews, setReviews] = useState<SignedMessageWithProof[]>([]);
  const [loading, setLoading] = useState(false);
  const [hasMore, setHasMore] = useState(true);
  const [error, setError] = useState("");
  const [pollInterval, setPollInterval] = useState(INITIAL_POLL_INTERVAL);
  const [showPollForm, setShowPollForm] = useState(false);
  const [polls, setPolls] = useState<any[]>([]);
  const [selectedPoll, setSelectedPoll] = useState<string | null>(null);

  // Refs
  const observer = useRef<IntersectionObserver | null>(null);
  const reviewListRef = useRef<HTMLDivElement>(null);

  const [myData, setMyData] = useState<any>(null);
  useEffect(() => {
    const fetchMyData = async () => {
      const message = "getMyData";
      const messageObj: Message = {
        id: crypto.randomUUID(),
        timestamp: new Date(),
        text: message,
        internal: !!isInternal,
        likes: 0,
        anonGroupId: "selfxyz",
        anonGroupProvider: "selfxyz",
      };

      const res = await getMyDataMessageCountry(messageObj);
      const myData = res?.credentialSubject;
      setMyData(myData);
    };
    fetchMyData();
  }, []);

  // Fetch polls
  const fetchPolls = useCallback(async () => {
    try {
      const response = await fetch('/api/poll/list');
      if (!response.ok) {
        throw new Error('Failed to fetch polls');
      }
      const data = await response.json();
      setPolls(data);
    } catch (error) {
      console.error('Error fetching polls:', error);
    }
  }, []);

  useEffect(() => {
    fetchPolls();
  }, [fetchPolls]);

  // Ref to keep track of the last review element (to load more reviews on scroll)
  const lastReviewElementRef = useCallback(
    (node: HTMLDivElement | null) => {
      if (loading) return;
      if (observer.current) observer.current.disconnect();
      observer.current = new IntersectionObserver((entries) => {
        if (entries[0].isIntersecting && hasMore) {
          loadReviews(reviews[reviews.length - 1]?.timestamp.getTime());
        }
      });
      if (node) observer.current.observe(node);
    },
    [reviews, loading, hasMore]
  );

  // Cached helpers
  const loadReviews = useCallback(
    async (beforeTimestamp: number | null = null) => {
      if (isInternal && !groupId) return;
      setLoading(true);

      try {
        const response = await fetch(`/api/poll/list?isInternal=${!!isInternal}&limit=${MESSAGES_PER_PAGE}&beforeTimestamp=${beforeTimestamp}&groupId=${groupId}`);
        if (!response.ok) {
          throw new Error('Failed to fetch polls');
        }
        const fetchedReviews = await response.json();

        const existingReviewIds: Record<string, boolean> = {};
        reviews.forEach((r) => {
          existingReviewIds[r.id!] = true;
        });
        const cleanedReviews = fetchedReviews.filter(
          (r: SignedMessageWithProof) => !existingReviewIds[r.id!]
        );

        setReviews((prevReviews) => [...prevReviews, ...cleanedReviews]);
        setHasMore(fetchedReviews.length === MESSAGES_PER_PAGE);
      } catch (error) {
        setError((error as Error)?.message);
      } finally {
        setLoading(false);
      }
    },
    [groupId, isInternal]
  );

  const checkForNewReviews = useCallback(async () => {
    if (isInternal && !groupId) return;

    try {
      const response = await fetch(`/api/poll/list?isInternal=${!!isInternal}&limit=${MESSAGES_PER_PAGE}&afterTimestamp=${reviews[0]?.timestamp.getTime()}&groupId=${groupId}`);
      if (!response.ok) {
        throw new Error('Failed to fetch polls');
      }
      const newReviews = await response.json();

      if (newReviews.length > 0) {
        setReviews((prevReviews) => [...newReviews, ...prevReviews]);
        setPollInterval(INITIAL_POLL_INTERVAL);
      } else {
        setPollInterval((prevInterval) =>
          Math.min(prevInterval + 10000, MAX_POLL_INTERVAL)
        );
      }
    } catch (error) {
      console.error("Error checking for new reviews:", error);
    }
  }, [groupId, isInternal, reviews]);

  // Effects
  useEffect(() => {
    let intervalId: NodeJS.Timeout;

    const startPolling = () => {
      intervalId = setInterval(() => {
        if (reviewListRef.current && reviewListRef.current.scrollTop === 0) {
          checkForNewReviews();
        }
      }, pollInterval);
    };

    startPolling();

    return () => {
      if (intervalId) clearInterval(intervalId);
    };
  }, [pollInterval, checkForNewReviews]);

  useEffect(() => {
    loadReviews();
  }, [loadReviews]);

  // Handlers
  const handlePollCreated = async (poll: any) => {
    try {
      const response = await fetch('/api/poll/create', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(poll),
      });

      if (!response.ok) {
        throw new Error('Failed to create poll');
      }

      const createdPoll = await response.json();
      setPolls(prevPolls => [createdPoll, ...prevPolls]);
      setShowPollForm(false);
    } catch (error) {
      console.error('Error creating poll:', error);
    }
  };

  const handleVote = async (pollId: string, option: string) => {
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

      if(!signature || !ephemeralPubkey || !ephemeralPubkeyExpiry) {
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

      setSelectedPoll(pollId);
      // Refresh polls to show updated results
      fetchPolls();
    } catch (error) {
      console.error('Error voting:', error);
      // Show error message to user
      setError((error as Error).message);
    }
  };

  // Render helpers
  function renderLoading() {
    return (
      <div className="skeleton-loader">
        {[...Array(4)].map((_, index) => (
          <div key={index} className="review-card-skeleton">
            <div className="review-card-skeleton-header">
              <div className="skeleton-text skeleton-short"></div>
            </div>
            <div className="skeleton-text skeleton-long mt-1"></div>
            <div className="skeleton-text skeleton-long mt-05"></div>
          </div>
        ))}
      </div>
    );
  }

  function renderNoReviews() {
    if (!groupId) return null;

    return (
      <div className="article text-center">
        <p className="title">No reviews yet</p>
        <p className="mb-05">
          Be the first to leave a review!
        </p>
      </div>
    );
  }

  return (
    <div className="review-list-container">
      <button 
        className="create-poll-button"
        onClick={() => setShowPollForm(true)}
      >
        Create Review Poll
      </button>

      {showPollForm && (
        <Dialog 
          title="Create Review Poll" 
          onClose={() => setShowPollForm(false)}
        >
          <ReviewPollForm 
            onSubmit={handlePollCreated} 
            connectedKyc={myData} 
          />
        </Dialog>
      )}

      <div className="review-list" ref={reviewListRef}>
        {polls.map((poll, index) => (
          <div
            key={poll.id || index}
            ref={index === polls.length - 1 ? lastReviewElementRef : null}
          >
            <PollCard
              review={poll}
              isInternal={isInternal}
              // onVote={handleVote}
            />
          </div>
        ))}
        {loading && renderLoading()}
        {!loading && !error && polls.length === 0 && renderNoReviews()}
      </div>

      {error && <div className="error-message">{error}</div>}
    </div>
  );
};

export default ReviewList;
