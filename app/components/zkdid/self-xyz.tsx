'use client';

import { loadOrInitializeEphemeralKey } from '@/lib/zk-did';
import React, { useState, useEffect } from 'react';
import { v4 as uuidv4 } from 'uuid';

function SelfXyzRegistration() {
  const [userId, setUserId] = useState<string | null>(null);
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

    const loadEphemeralKey = async () => {
      const { ephemeralKey, uuid } = await loadOrInitializeEphemeralKey();
      setUserId(uuid);
    }

    if (!userId) {
      loadEphemeralKey();
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
    endpoint: process.env.NEXT_PUBLIC_SELF_VERIFY_URL as string ?? "https://privacy-afk-community.xyz/api/register/self-xyz",
    userId,
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
    </div>
  );
}

export default SelfXyzRegistration;