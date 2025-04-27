import type { NextApiRequest, NextApiResponse } from "next";
import { createClient } from "@supabase/supabase-js";
import { ZKPassport } from "@zkpassport/sdk";
import { getUserIdentifier, SelfBackendVerifier, countryCodes } from '@selfxyz/core';

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

const SELF_SCOPE_URL = process.env.SELF_SCOPE_URL as string;
const SELF_VERIFY_URL = process.env.SELF_VERIFY_URL as string;

if (!supabaseUrl || !supabaseKey) {
  throw new Error("Missing Supabase environment variables");
}

const supabase = createClient(supabaseUrl, supabaseKey);

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  const {pubkey} = req.query;
  console.log("pubkey:", pubkey);


  const header = req.headers;
  console.log("Header:", header);


  if (req.method === 'POST') {
    try {
      const { proof, publicSignals, publicKey, ephemeralKey } = req.body;


      console.log("Proof:", proof);
      console.log("PublicSignals:", publicSignals);
      console.log("PublicKey:", publicKey);
      console.log("EphemeralKey:", ephemeralKey);

      if (!proof || !publicSignals) {
        return res.status(400).json({ message: 'Proof and publicSignals are required' });
      }

      // Extract user ID from the proof
      const userId = await getUserIdentifier(publicSignals);
      console.log("Extracted userId:", userId);

      // Initialize and configure the verifier
      const selfBackendVerifier = new SelfBackendVerifier(
        SELF_SCOPE_URL ?? 'scope-verify-afk-privacy',
        SELF_VERIFY_URL ?? 'https://privacy.afk-community.xyz/api/register/self-xyz'
      );

      // Verify the proof
      const result = await selfBackendVerifier.verify(proof, publicSignals);

      console.log("Result:", result);
      if (result.isValid) {

        const { error: insertError } = await supabase.from("passport_registrations").update({
          is_verified: true,
          proof: proof,
          proof_args: publicSignals,
          nationality: result.credentialSubject.nationality,
          date_of_birth: result.credentialSubject.date_of_birth,
          gender: result.credentialSubject.gender,
        }).eq("id_register", userId);

        console.log("Inserted passport registration:", insertError);
        // Return successful verification response
        return res.status(200).json({
          status: 'success',
          result: true,
          credentialSubject: result.credentialSubject,
          proof: proof,
        });
      } else {
        // Return failed verification response
        return res.status(500).json({
          status: 'error',
          result: false,
          message: 'Verification failed',
          details: result.isValidDetails
        });
      }
    } catch (error) {
      console.error('Error verifying proof:', error);
      return res.status(500).json({
        status: 'error',
        result: false,
        message: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  } else {
    return res.status(405).json({ message: 'Method not allowed' });
  }
}