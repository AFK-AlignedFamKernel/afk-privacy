import { Message, SignedMessage, SignedMessageWithProof } from "../types";
import { getEphemeralPubkey } from "../ephemeral-key";
import { signMessageSelfXyz } from "../zk-did";

export async function createReview(signedMessage: SignedMessage) {
  const response = await fetch("/api/country/messages/create", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      ...signedMessage,
      ephemeralPubkey: signedMessage.ephemeralPubkey.toString(),
      signature: signedMessage.signature.toString(),
    }),
  });

  if (!response.ok) {
    const errorMessage = await response.text();
    console.error(`Call to /messages API failed: ${errorMessage}`);
    throw new Error("Call to /messages API failed");
  }
}

export async function handleCreateReview(message: Message) {
  try {
    // Sign the message with the ephemeral key pair
    const { signature, ephemeralPubkey, ephemeralPubkeyExpiry } = await signMessageSelfXyz(message);
    if (!signature || !ephemeralPubkey || !ephemeralPubkeyExpiry) {
      throw new Error("Failed to sign message");
    }
    const signedMessage: SignedMessage = {
      ...message,
      signature: signature,
      ephemeralPubkey: ephemeralPubkey,
      ephemeralPubkeyExpiry: ephemeralPubkeyExpiry,
    };

    // Send the signed message to the server
    await createReview(signedMessage);

    return signedMessage;
  } catch (error) {
    console.error("Error creating review:", error);
    throw error;
  }
}