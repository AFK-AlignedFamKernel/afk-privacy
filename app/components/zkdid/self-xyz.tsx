'use client';

import React, { useState, useEffect } from 'react';
import { v4 as uuidv4 } from 'uuid';

function SelfXyzRegistration() {
  const [userId, setUserId] = useState<string | null>(null);
  const [isClient, setIsClient] = useState(false);
  const [SelfComponents, setSelfComponents] = useState<any>(null);

  useEffect(() => {
    setIsClient(true);
    setUserId(uuidv4());
    
    // Import the SelfXYZ components only on the client side
    import('@selfxyz/qrcode').then(module => {
      setSelfComponents({
        SelfQRcodeWrapper: module.default,
        SelfAppBuilder: module.SelfAppBuilder
      });
    });
  }, []);

  if (!isClient || !userId || !SelfComponents) return null;

  // Create the SelfApp configuration
  const selfApp = new SelfComponents.SelfAppBuilder({
    appName: "AFK Privacy",
    scope: process.env.NEXT_PUBLIC_SELF_SCOPE_URL ?? "scope-verify-afk-privacy",
    endpoint: process.env.NEXT_PUBLIC_SELF_VERIFY_URL ?? "https://privacy-afk-community.xyz/api/register/self-xyz",
    userId,
  }).build();

  return (
    <div className="verification-container">
      <h1>Verify Your Identity</h1>
      <p>Scan this QR code with the Self app to verify your identity</p>
      
      <SelfComponents.SelfQRcodeWrapper
        selfApp={selfApp}
        onSuccess={() => {
          // Handle successful verification
          console.log("Verification successful!");
          // Redirect or update UI
        }}
        size={350}
      />
      
      <p className="text-sm text-gray-500">
        User ID: {userId.substring(0, 8)}...
      </p>
    </div>
  );
}

export default SelfXyzRegistration;