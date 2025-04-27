import { Barretenberg, Fr } from "@aztec/bb.js";
import * as ed25519 from '@noble/ed25519';
import { sha512 } from '@noble/hashes/sha512';
import { EphemeralKey, LocalStorageKeys, Message, SignedMessage } from "./types";
import { bytesToBigInt, bigIntToBytes } from "./utils";
import { v4 as uuidv4 } from 'uuid';

ed25519.etc.sha512Sync = (...m) => sha512(ed25519.etc.concatBytes(...m));

export async function generateEphemeralKey(): Promise<{ ephemeralKey: EphemeralKey, uuid: string }> {
  const privKey = ed25519.utils.randomPrivateKey();
  const privKeyBigInt = bytesToBigInt(privKey);

  const pubKey = await ed25519.getPublicKeyAsync(privKey);
  const pubKeyBigInt = bytesToBigInt(pubKey);

  const salt = ed25519.utils.randomPrivateKey().slice(0, 30); // a random 30 byte salt
  const saltBigInt = bytesToBigInt(salt);

  const expiry = Date.now() + 7 * 24 * 60 * 60 * 1000; // 1 week from now

  const bb = await Barretenberg.new();
  const ephemeralPubkeyHash = await bb.poseidon2Hash([
    new Fr(pubKeyBigInt >> 3n),
    new Fr(saltBigInt),
    new Fr(BigInt(Math.floor(expiry / 1000))),
  ]);
  const ephemeralPubkeyHashBigInt = bytesToBigInt(ephemeralPubkeyHash.value);

  const ephemeralKey: EphemeralKey = {
    privateKey: privKeyBigInt,
    publicKey: pubKeyBigInt,
    salt: saltBigInt,
    expiry: new Date(expiry),
    ephemeralPubkeyHash: ephemeralPubkeyHashBigInt,
  };
  const uuid = uuidv4();

  saveEphemeralKey(ephemeralKey, uuid);

  return { ephemeralKey, uuid }; // no need to expose private key outside this file
}

function saveEphemeralKey(ephemeralKey: EphemeralKey, uuid: string) {
  localStorage.setItem(LocalStorageKeys.EphemeralKey, JSON.stringify({
    ephemeralKey: {
      privateKey: ephemeralKey?.privateKey?.toString(),
      publicKey: ephemeralKey?.publicKey?.toString(),
      salt: ephemeralKey?.salt?.toString(),
      expiry: ephemeralKey?.expiry,
      ephemeralPubkeyHash: ephemeralKey?.ephemeralPubkeyHash?.toString(),
    },
    uuid: uuid,
  }));
}

function loadEphemeralKey() {
  try {
    const ephemeralKeyString = localStorage.getItem(LocalStorageKeys.EphemeralKey);
    if (!ephemeralKeyString) {
      return {
        ephemeralKey: null,
        uuid: null,
      };
    }

    const ephemeralKey = JSON.parse(ephemeralKeyString);

    if (!ephemeralKey) {
      return {
        ephemeralKey: null,
        uuid: null,
      };
    }

    return {
      ephemeralKey: {
        privateKey: BigInt(ephemeralKey?.privateKey),
        publicKey: BigInt(ephemeralKey?.publicKey),
        salt: BigInt(ephemeralKey?.salt),
        expiry: ephemeralKey?.expiry,
        ephemeralPubkeyHash: ephemeralKey?.ephemeralPubkeyHash ? BigInt(ephemeralKey?.ephemeralPubkeyHash) : null,
      },
      uuid: ephemeralKey.uuid,
    };
  } catch (error) {
    console.error("Error loading ephemeral key", error);
    return {
      ephemeralKey: null,
      uuid: null,
    };
  }
}
export function hasEphemeralKey() {
  const { ephemeralKey } = loadEphemeralKey();
  if (!ephemeralKey) {
    return false;
  }

  const isExpired = new Date(Number(ephemeralKey?.expiry) * 1000) < new Date();
  if (isExpired) {
    localStorage.removeItem(LocalStorageKeys.EphemeralKey);
    return false;
  }

  return true;
}

export function getEphemeralPubkey() {
  const { ephemeralKey } = loadEphemeralKey();
  if (!ephemeralKey) {
    return null;
  }
  return ephemeralKey?.publicKey;
}

export async function signMessage(message: Message) {
  const { ephemeralKey } = loadEphemeralKey();
  if (!ephemeralKey) {
    throw new Error("No ephemeralKey found");
  }

  const messageHash = await hashMessage(message);

  const signature = await ed25519.signAsync(messageHash, bigIntToBytes(ephemeralKey.privateKey, 32));
  const signatureBigInt = bytesToBigInt(signature);

  return {
    ephemeralPubkey: ephemeralKey.publicKey,
    ephemeralPubkeyExpiry: ephemeralKey.expiry,
    signature: signatureBigInt,
  };
}

export async function verifyMessageSignature(message: SignedMessage) {
  const pubkey = bigIntToBytes(message.ephemeralPubkey, 32);
  const messageHash = await hashMessage(message);

  const isValid = await ed25519.verify(
    bigIntToBytes(message.signature, 64),
    messageHash,
    pubkey
  );
  console.log("isValid", isValid);

  if (!isValid) {
    console.error("Signature verification failed for the message");
  }

  return isValid;
}

async function hashMessage(message: Message) {
  const messageStr = `${message.anonGroupId}_${message.text}_${message.timestamp.getTime()}`;
  const messageHash = await globalThis.crypto.subtle.digest('SHA-256', new TextEncoder().encode(messageStr));
  return new Uint8Array(messageHash);
}

