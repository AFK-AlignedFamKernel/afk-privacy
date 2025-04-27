import type { Message, SignedMessage, SignedMessageWithProof } from "./types";
import { createMembership, createMessage, createLinkSelfXyz } from "./api";
import { signMessageSelfXyz } from "./zk-did";
import { initProver } from "./lazy-modules";
import { Providers } from "./providers";


export async function postLinkSelfXyz(message: Message, uuid: string) {
    // Sign the message with the ephemeral key pair
    const { signature, ephemeralPubkey, ephemeralPubkeyExpiry } = await signMessageSelfXyz(message);
    if (!signature || !ephemeralPubkey || !ephemeralPubkeyExpiry) {
      throw new Error("Failed to sign message");
    }
    const signedMessage: SignedMessage = {
      ...message,
      signature: signature,
      ephemeralPubkey: BigInt(ephemeralPubkey),
      ephemeralPubkeyExpiry: ephemeralPubkeyExpiry,
    };
  
    // Send the signed message to the server
    await createLinkSelfXyz(signedMessage, uuid);
  
    return signedMessage;
  }