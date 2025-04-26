'use client';

import { postLinkSelfXyz } from '@/lib/self-xyz';
import { loadOrInitializeEphemeralKey } from '@/lib/zk-did';
import React, { useState, useEffect } from 'react';
import { v4 as uuidv4 } from 'uuid';

function SelfXyzRegistration() {
  const [userId, setUserId] = useState<string | null>(null);
  const [pubkey, setPubkey] = useState<string | null>(null);
  const [isClient, setIsClient] = useState(false);
  const [SelfComponents, setSelfComponents] = useState<any>(null);

  useEffect(() => {
    setIsClient(true);

    // Import the SelfXYZ components only on the client side
    import('@selfxyz/qrcode').then(module => {
      setSelfComponents({
        SelfQRcodeWrapper: module.default,
        SelfAppBuilder: module.SelfAppBuilder
      });
    });
  }, []);

  useEffect(() => {

    const loadEphemeralKeySelfXyz = async () => {
      const { ephemeralKey, uuid } = await loadOrInitializeEphemeralKey();
      // setUserId(`0x${ephemeralKey?.publicKey?.toString()}`);

      const messageObj = {
        id: crypto.randomUUID(),
        timestamp: new Date(),
        text: `link-selfxyz:${uuid}`,
        internal: false,
        likes: 0,
        replyCount: 0,
        parentId: null,
        anonGroupId: "selfxyz",
        anonGroupProvider: "selfxyz",
      };


      const signedMessage = await postLinkSelfXyz(messageObj, uuid);
      // onCommentAdded(signedMessage as SignedMessageWithProof);

      if(!signedMessage) {
        throw new Error("Failed to post link-selfxyz");
      }
      setUserId(uuid);
      setPubkey(ephemeralKey?.publicKey?.toString());
    }

    if (!userId) {
      loadEphemeralKeySelfXyz();
      setIsClient(true);

    }

  }, [userId]);

  if (!isClient || !userId || !SelfComponents) return null;

  // Create the SelfApp configuration
  console.log("process.env.NEXT_PUBLIC_SELF_SCOPE_URL", process.env.NEXT_PUBLIC_SELF_SCOPE_URL);
  console.log("process.env.NEXT_PUBLIC_SELF_VERIFY_URL", process.env.NEXT_PUBLIC_SELF_VERIFY_URL);
  const selfApp = new SelfComponents.SelfAppBuilder({
    appName: "AFK Privacy",
    scope: process.env.NEXT_PUBLIC_SELF_SCOPE_URL as string ?? "scope-verify-afk-privacy",
    endpoint: process.env.NEXT_PUBLIC_SELF_VERIFY_URL as string
      ? `${process.env.NEXT_PUBLIC_SELF_VERIFY_URL}/api/register/self-xyz`
      : `https://privacy-afk-community.xyz/api/register/self-xyz`,

      // ? `${process.env.NEXT_PUBLIC_SELF_VERIFY_URL}/api/register/self-xyz?pubkey=${pubkey}`
      // : `https://privacy-afk-community.xyz/api/register/self-xyz?pubkey=${pubkey}`,
      // : `https://privacy-afk-community.xyz/api/register/self-xyz?pubkey=${pubkey}`,
    header:pubkey,
    userId,
    // userIdType: "hex",
    endpointType: "https",
    disclosures: {
      nationality: true,
      gender: true,
      expiry_date: true,
      date_of_birth: true,
    },
    devMode: true,
  }).build();

  return (
    <div className="verification-container">
      <h1>Verify Your Identity</h1>
      <p>Scan this QR code with the Self app to verify your identity</p>

      <SelfComponents.SelfQRcodeWrapper
        selfApp={selfApp}
        onSuccess={(e: any) => {
          // Handle successful verification
          console.log("Verification successful!");
          console.log("E:", e);
          // Redirect or update UI
        }}
        // type="deeplink"
        size={350}
      />

      <p className="text-sm text-gray-500">
        User ID: {userId.substring(0, 8)}...
      </p>

      <p className="text-sm text-gray-500">
        Public Key: {pubkey}
      </p>
    </div>
  );
}

export default SelfXyzRegistration;