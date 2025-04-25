import React, { useState } from "react";
import dynamic from "next/dynamic";
import { useLocalStorage } from "@uidotdev/usehooks";
import IonIcon from "@reacticons/ionicons";
import { LocalStorageKeys, Message, SignedMessageWithProof } from "../lib/types";
import { getEphemeralPubkey } from "../lib/ephemeral-key";
import { generateKeyPairAndRegister, postMessage } from "../lib/core";
import { generateNameFromPubkey } from "../lib/utils";
import { Providers } from "../lib/providers";
import SignWithGoogleButton from "./siwg";
// import SignInWithMicrosoftButton from "./siwm";

interface CommentFormProps {
  parentId: string;
  isInternal?: boolean;
  onCommentAdded: (comment: SignedMessageWithProof) => void;
}

const CommentForm: React.FC<CommentFormProps> = ({
  parentId,
  isInternal,
  onCommentAdded,
}) => {
  const [comment, setComment] = useState("");
  const [isPosting, setIsPosting] = useState(false);
  const [currentGroupId] = useLocalStorage<string | null>(
    LocalStorageKeys.CurrentGroupId,
    null
  );
  const [currentProvider] = useLocalStorage<string | null>(
    LocalStorageKeys.CurrentProvider,
    null
  );

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!comment.trim()) return;

    setIsPosting(true);
    try {
      const messageObj = {
        id: crypto.randomUUID(),
        timestamp: new Date(),
        text: comment,
        internal: !!isInternal,
        likes: 0,
        replyCount: 0,
        parentId,
        anonGroupId: currentGroupId as string,
        anonGroupProvider: currentProvider as string,
      };

      const signedMessage = await postMessage(messageObj);
      onCommentAdded(signedMessage as SignedMessageWithProof);
      setComment("");
    } catch (error) {
      console.error("Error posting comment:", error);
    } finally {
      setIsPosting(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="comment-form">
      <textarea
        value={comment}
        onChange={(e) => setComment(e.target.value)}
        placeholder="Write a comment..."
        disabled={isPosting}
      />
      <button type="submit" disabled={isPosting || !comment.trim()}>
        {isPosting ? "Posting..." : "Post Comment"}
      </button>
    </form>
  );
};

export default dynamic(() => Promise.resolve(CommentForm), {
  ssr: false,
});
