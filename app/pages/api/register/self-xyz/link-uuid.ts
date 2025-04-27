import type { NextApiRequest, NextApiResponse } from "next";
import { createClient } from "@supabase/supabase-js";
import { ZKPassport } from "@zkpassport/sdk";
import { getUserIdentifier, SelfBackendVerifier, countryCodes } from '@selfxyz/core';
import { SignedMessage } from "@/lib/types";
import { verifyMessageSignature } from "@/lib/zk-did";

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

const SELF_SCOPE_URL = process.env.SELF_SCOPE_URL as string;
const SELF_VERIFY_URL = process.env.SELF_VERIFY_URL as string;

if (!supabaseUrl || !supabaseKey) {
  throw new Error("Missing Supabase environment variables");
}

const supabase = createClient(supabaseUrl, supabaseKey);

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  const { pubkey } = req.query;
  console.log("pubkey:", pubkey);


  let header = req.headers;
  console.log("Header:", header);


  if (req.method === 'POST') {
    try {
      const { uuid, pubkey, signAsync } = req.body;
      const body = (await req.body);
      console.log("Body:", body);

      const signedMessage: SignedMessage = {
        id: body.id,
        anonGroupId: body.anonGroupId,
        anonGroupProvider: body.anonGroupProvider,
        text: body.text,
        timestamp: new Date(body.timestamp),
        internal: body.internal,
        signature: BigInt(body.signature),
        ephemeralPubkey: BigInt(body.ephemeralPubkey),
        ephemeralPubkeyExpiry: new Date(body.ephemeralPubkeyExpiry),
        likes: 0,
        parentId: body?.parentId || null,
        replyCount: 0
      }


      console.log("UUID:", uuid);
      console.log("Pubkey:", pubkey);
      console.log("SignAsync:", signAsync);
      console.log("signMessage:", signedMessage);

      if (!uuid || !pubkey) {
        return res.status(400).json({ message: 'UUID, pubkey and signAsync are required' });
      }


      const isValid = await verifyMessageSignature(signedMessage);
      console.log("isValid:", isValid);
      if (!isValid) {
        throw new Error("Message signature check failed");
      }


      // Verify pubkey is registered
      const { data, error } = await supabase
        .from("ephemeral_keys")
        .select("*")
        .eq("pubkey", signedMessage.ephemeralPubkey.toString())
        .single();


      if (!data) {

        await supabase
          .from("ephemeral_keys")
          .insert({
            pubkey: signedMessage.ephemeralPubkey.toString(),
            signature: signedMessage.signature.toString(),
            uuid: uuid,
          })

        // throw new Error("Ephemeral key not registered");
      }

      const { data: passportRegistrationFind, error: passportRegistrationFindError } = await supabase
        .from("passport_registrations")
        .select("*")
        .eq("pubkey", signedMessage.ephemeralPubkey.toString())
        .single();

      if (passportRegistrationFind) {
        console.log("Passport registration found");
      }

      // created_at: new Date().toISOString(),

      if (!passportRegistrationFind) {
        const { data: passportRegistration, error: passportRegistrationError } = await supabase
          .from("passport_registrations")
          .insert({
            provider: signedMessage.anonGroupProvider,
            pubkey: signedMessage.ephemeralPubkey.toString(),
            id_register: uuid,
            signature: signedMessage.signature.toString(),
            is_verified: false,
            group_id: uuid,
            // created_at: new Date().toISOString(),
            ephemeral_key_id: data.id,
            // signature: signedMessage.signature.toString(),
          })


        if (passportRegistrationError) {
          console.error('Error registering passport registration:', passportRegistrationError);
          throw new Error("Failed to register passport registration");
        }
        if (!passportRegistration) {
          // throw new Error("Failed to register passport registration");
        }

        return res.status(200).json({
          status: 'success',
          result: true,
          message: 'Ephemeral key registered'
        });


      }


      return res.status(200).json({
        status: 'success',
        result: true,
        message: 'Ephemeral key registered'
      });

    } catch (error) {
      console.error('Error init ephemeral key and uuid for zk self xyz:', error);
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