import React, { useRef, useState, useEffect } from "react";
import Image from "next/image";
import TimeAgo from "javascript-time-ago";
import Link from "next/link";
import IonIcon from "@reacticons/ionicons";
import type { SignedMessageWithProof } from "../lib/types";
import { generateNameFromPubkey } from "../lib/utils";
import { setMessageLiked, isMessageLiked } from "../lib/store";
import { fetchMessageVerify, toggleLike, fetchMessages } from "../lib/api";
import { hasEphemeralKey } from "../lib/ephemeral-key";
import { verifyMessage } from "../lib/core";
import { Providers } from "../lib/providers";
import Dialog from "./dialog";
import CommentForm from "./comment-form";

interface MessageCardProps {
  message: SignedMessageWithProof;
  isInternal?: boolean;
}

type VerificationStatus = "idle" | "verifying" | "valid" | "invalid" | "error";


const MessageCard: React.FC<MessageCardProps> = ({ message, isInternal }) => {
  const timeAgo = useRef(new TimeAgo("en-US")).current;

  const provider = Providers[message?.anonGroupProvider];
  const anonGroup = provider.getAnonGroup(message.anonGroupId);

  // States
  const [likeCount, setLikeCount] = useState(message.likes || 0);
  const [isLiked, setIsLiked] = useState(isMessageLiked(message.id));
  const [verificationStatus, setVerificationStatus] =
    useState<VerificationStatus>("idle");
  const [showCommentDialog, setShowCommentDialog] = useState(false);
  const [comments, setComments] = useState<SignedMessageWithProof[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [parentMessage, setParentMessage] = useState<SignedMessageWithProof | null>(null);
  const [loadingParent, setLoadingParent] = useState(false);

  const isGroupPage = window.location.pathname === `/${provider.getSlug()}/${message.anonGroupId}`;
  const isMessagePage = window.location.pathname === `/messages/${message.id}`;

  // Fetch parent message if this is a reply
  useEffect(() => {
    if (message.parentId) {
      setLoadingParent(true);
      fetchMessageVerify(message.parentId, isInternal)
        .then(setParentMessage)
        .catch(console.error)
        .finally(() => setLoadingParent(false));
    }
  }, [message.parentId, isInternal]);

  // Handlers
  async function onLikeClick() {
    try {
      const newIsLiked = !isLiked;

      setIsLiked(newIsLiked);
      setLikeCount((prev: number) => (newIsLiked ? prev + 1 : prev - 1));
      setMessageLiked(message.id, newIsLiked);

      await toggleLike(message.id, newIsLiked);
    } catch (error) {
      setIsLiked(isLiked);
      setLikeCount(likeCount);
      setMessageLiked(message.id, isLiked);
    }
  }

  async function onVerifyClick() {
    setVerificationStatus("verifying");

    try {
      const fullMessage = await fetchMessageVerify(message.id, message.internal);
      console.log("fullMessage", fullMessage);
      const isValid = await verifyMessage(fullMessage);

      setVerificationStatus(isValid ? "valid" : "invalid");
    } catch (error) {
      console.error("Verification failed:", error);
      setVerificationStatus("error");
    }
  }

  const handleShowComments = async () => {
    setIsLoading(true);
    try {
      const fetchedComments = await fetchMessages({
        limit: 50,
        isInternal: message.internal,
        parentId: message.id
      });
      setComments(fetchedComments);
      setShowCommentDialog(true);
    } catch (error) {
      console.error("Error fetching comments:", error);
    } finally {
      setIsLoading(false);
    }
  };

  const handleCommentAdded = (newComment: SignedMessageWithProof) => {
    setComments(prev => [newComment, ...prev]);
    // Update the reply count in the UI
    message.replyCount = (message.replyCount || 0) + 1;
  };

  // Render Helpers
  function renderLogo() {
    if (isInternal) {
      return null;
    }

    const logoImg = (
      <Image
        src={anonGroup.logoUrl}
        alt={anonGroup.title}
        width={40}
        height={40}
      />
    );

    // Redirect to group page on logo click if not already on it
    if (!isGroupPage) {
      return (
        <Link
          href={`/${provider.getSlug()}/${message.anonGroupId}`}
          className="message-card-header-logo"
        >
          {logoImg}
        </Link>
      );
    }

    return <div className="message-card-header-logo">{logoImg}</div>;
  }

  function renderSender() {
    const timestampComponent = (
      <span
        className="message-card-header-timestamp"
        title={message.timestamp.toLocaleString()}
      >
        {timeAgo.format(new Date(message.timestamp))}
      </span>
    );

    if (isInternal) {
      return (
        <div className="message-card-header-sender-name internal">
          <span>{generateNameFromPubkey(message.ephemeralPubkey.toString())}</span>
          {timestampComponent}
        </div>
      );
    }

    return (
      <span>
        <div className="message-card-header-sender-text">
          <span>Someone from</span>
        </div>
        <div className="message-card-header-sender-name">
          {isGroupPage ? (
            <span>{anonGroup.title}</span>
          ) : (
            <Link href={`/domain/${message.anonGroupId}`}>{anonGroup.title}</Link>
          )}

          {isMessagePage ? (
            timestampComponent
          ) : (
            <Link href={`/messages/${message.id}`}>{timestampComponent}</Link>
          )}
        </div>
      </span>
    );
  }

  function renderVerificationStatus() {
    if (verificationStatus === "idle") {
      return (
        <span className="message-card-verify-button" onClick={onVerifyClick}>
          Verify
        </span>
      );
    }

    return (
      <span className={`message-card-verify-status ${verificationStatus}`}>
        {verificationStatus === "verifying" && (
          <span className="message-card-verify-icon spinner-icon small"></span>
        )}
        {verificationStatus === "valid" && (
          <span className="message-card-verify-icon valid">
            <IonIcon name="checkmark-outline" />
          </span>
        )}
        {verificationStatus === "invalid" && (
          <span className="message-card-verify-icon invalid">
            <IonIcon name="close-outline" />
          </span>
        )}
        {verificationStatus === "error" && (
          <span className="message-card-verify-icon error">
            <IonIcon name="alert-outline" />
          </span>
        )}
      </span>
    );
  }

  // Render
  return (
    <div className="message-card" data-is-reply={!!message.parentId}>
      {/* Reply Note */}
      {message.parentId && (
        <div className="message-card-reply-note">
          <IonIcon name="return-up-back-outline" />
          <span>
            Replying to{" "}
            {loadingParent ? (
              <span className="loading-dots">...</span>
            ) : parentMessage ? (
              <span className="reply-author">
                {generateNameFromPubkey(parentMessage?.ephemeralPubkey?.toString() || "")}
              </span>
            ) : (
              <span className="deleted-message">deleted message</span>
            )}
          </span>
        </div>
      )}

      <header className="message-card-header">
        <div className="message-card-header-sender">
          {renderLogo()}
          {renderSender()}
        </div>

        {renderVerificationStatus()}
      </header>

      <main className="message-card-content">{message.text}</main>

      <div className="message-card-footer">
        <div className="like-button-container">
          <button
            onClick={onLikeClick}
            disabled={!hasEphemeralKey()}
            className={`like-button ${isLiked ? "liked" : ""}`}
          >
            <IonIcon name={isLiked ? "heart" : "heart-outline"} />
            <span className="like-count">{likeCount}</span>
          </button>
        </div>
        <div className="message-card-actions">
          <button 
            onClick={handleShowComments}
            className="message-card-action-button"
            disabled={isLoading}
          >
            <IonIcon name="chatbubble-outline" />
            <span>{message.replyCount || 0}</span>
          </button>
        </div>
      </div>

      {showCommentDialog && (
        <Dialog
          title="Comments"
          onClose={() => setShowCommentDialog(false)}
        >
          <div className="comments-container">
            <CommentForm
              parentId={message.id}
              isInternal={isInternal}
              onCommentAdded={handleCommentAdded}
            />
            <div className="comments-list">
              {isLoading ? (
                <div className="loading-spinner">Loading comments...</div>
              ) : comments.length > 0 ? (
                comments.map((comment) => (
                  <MessageCard
                    key={comment.id}
                    message={comment}
                    isInternal={isInternal}
                  />
                ))
              ) : (
                <div className="no-comments">No comments yet</div>
              )}
            </div>
          </div>
        </Dialog>
      )}
    </div>
  );
};

export default MessageCard;
