import { Message, SignedMessage, SignedMessageWithProof } from "../types";
import { getEphemeralPubkey } from "../ephemeral-key";
import { signMessageSelfXyz } from "../zk-did";

export async function fetchMyDataMessageCountry(signedMessage: SignedMessage) {
  try {
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
  } catch (error) {
    console.error("Error getting my data message country", error);
    return error;
  }
}


export async function getMyDataMessageCountry(message: Message) {
  try {
    // Sign the message with the ephemeral key pair
    const { signature, ephemeralPubkey, ephemeralPubkeyExpiry } = await signMessageSelfXyz(message);

    if (!signature || !ephemeralPubkey || !ephemeralPubkeyExpiry) {
      return null;
    }

    const signedMessage: SignedMessage = {
      ...message,
      signature: signature,
      ephemeralPubkey: ephemeralPubkey,
      ephemeralPubkeyExpiry: ephemeralPubkeyExpiry,
    };

    // Send the signed message to the server
    const response = await fetchMyDataMessageCountry(signedMessage);

    // console.log("response", response);
    return response;
  } catch (error) {
    console.error("Error getting my data message country", error);
    return error;
  }
}
