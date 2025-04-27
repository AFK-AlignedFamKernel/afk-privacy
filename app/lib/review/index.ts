import { Message, SignedMessage, SignedMessageWithProof } from "../types";
import { getEphemeralPubkey } from "../ephemeral-key";
import { signMessageSelfXyz } from "../zk-did";

export async function fetchMessagesCountry({
  limit,
  groupId,
  isInternal,
  beforeTimestamp,
  afterTimestamp,
  parentId,
}: {
  limit: number;
  isInternal?: boolean;
  groupId?: string;
  beforeTimestamp?: number | null;
  afterTimestamp?: number | null;
  parentId?: string | null;
}) {
  const url = new URL(window.location.origin + "/api/country/messages");

  url.searchParams.set("limit", limit.toString());
  if (groupId) url.searchParams.set("groupId", groupId);
  if (isInternal) url.searchParams.set("isInternal", "true");
  if (afterTimestamp) url.searchParams.set("afterTimestamp", afterTimestamp.toString());
  if (beforeTimestamp) url.searchParams.set("beforeTimestamp", beforeTimestamp.toString());
  if (parentId) url.searchParams.set("parentId", parentId);

  const headers: HeadersInit = {
    "Content-Type": "application/json",
  };

  if (isInternal) {
    const pubkey = getEphemeralPubkey();
    if (!pubkey) {
      throw new Error("No public key found");
    }
    headers["Authorization"] = `Bearer ${pubkey}`;
  }

  const response = await fetch(url, { headers });

  if (!response.ok) {
    const errorMessage = await response.text();
    throw new Error(`Call to /messages API failed: ${errorMessage}`);
  }

  const messages = await response.json();
  return messages.map((message: Message) => ({
    ...message,
    timestamp: new Date(message.timestamp),
  }));
}

export async function fetchMessageCountry(
  id: string,
  isInternal: boolean = false
): Promise<SignedMessageWithProof> {
  const headers: HeadersInit = {
    "Content-Type": "application/json",
  };

  if (isInternal) {
    const pubkey = getEphemeralPubkey();
    if (!pubkey) {
      throw new Error("No public key found");
    }
    headers["Authorization"] = `Bearer ${pubkey}`;
  }

  const response = await fetch(`/api/country/messages/${id}`, { headers });

  if (!response.ok) {
    const errorMessage = await response.text();
    throw new Error(`Call to /messages/${id} API failed: ${errorMessage}`);
  }

  const message = await response.json();
  try {
    message.signature = BigInt(message.signature);
    message.ephemeralPubkey = BigInt(message.ephemeralPubkey);
    message.ephemeralPubkeyExpiry = new Date(message.ephemeralPubkeyExpiry);
    message.timestamp = new Date(message.timestamp);
    message.proof = Uint8Array.from(message.proof);
  } catch (error) {
    console.warn("Error parsing message:", error);
  }

  return message;
}

export async function createMembershipCountry({
  ephemeralPubkey,
  ephemeralPubkeyExpiry,
  groupId,
  provider,
  proof,
  proofArgs
}: {
  ephemeralPubkey: string;
  ephemeralPubkeyExpiry: Date;
  groupId: string;
  provider: string;
  proof: Uint8Array;
  proofArgs: object;
}) {
  const response = await fetch("/api/country/memberships", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      ephemeralPubkey,
      ephemeralPubkeyExpiry: ephemeralPubkeyExpiry.toISOString(),
      groupId,
      provider,
      proof: Array.from(proof),
      proofArgs,
    }),
  });

  if (!response.ok) {
    const errorMessage = await response.text();
    console.error(`Call to /memberships API failed: ${errorMessage}`);
    throw new Error("Call to /memberships API failed");
  }
}

export async function createMessageReview(signedMessage: SignedMessage) {
  const response = await fetch("/api/country/messages", {
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

export async function toggleLikeCountry(messageId: string, like: boolean) {
  try {
    const pubkey = getEphemeralPubkey();

    const response = await fetch("/api/country/likes", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${pubkey}`,
      },
      body: JSON.stringify({
        messageId,
        like,
      }),
    });

    if (!response.ok) {
      const errorMessage = await response.text();
      console.error(`Call to /likes API failed: ${errorMessage}`);
      throw new Error("Call to /likes API failed");
    }

    const data = await response.json();
    return data.liked;
  } catch (error) {
    console.error("Error toggling like:", error);
    throw error;
  }
}


export async function createLinkSelfXyz(signedMessage: SignedMessage, uuid: string) {
  const response = await fetch("/api/register/self-xyz/link-uuid", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      ...signedMessage,
      pubkey: signedMessage.ephemeralPubkey.toString(),
      ephemeralPubkey: signedMessage.ephemeralPubkey.toString(),
      signature: signedMessage.signature.toString(),

      uuid: uuid,
    }),
  });

  if (!response.ok) {
    const errorMessage = await response.text();
    console.error(`Call to /messages API failed: ${errorMessage}`);
    throw new Error("Call to /messages API failed");
  }
}
export async function postMessageCountry(message: Message) {
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
    await createMessageReview(signedMessage);

    return signedMessage;
  } catch (error) {
    console.error("Error posting message:", error);
    throw error;
  }

}

export async function fetchMyDataMessageCountry(signedMessage: SignedMessage) {
  const response = await fetch("/api/country/profile", {
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

  const data = await response.json();
  return data;
}


export async function getMyDataMessageCountry(message: Message) {
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
    const response = await fetchMyDataMessageCountry(signedMessage);

    console.log("response", response);
    return response;
  } catch (error) {
    console.error("Error getting my data message country:", error);
    throw error;
  }
}


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