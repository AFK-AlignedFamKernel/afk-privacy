import type { NextApiRequest, NextApiResponse } from "next";
import { createClient } from "@supabase/supabase-js";
import { verifyMessageSignature } from "../../../lib/ephemeral-key";
import { SignedMessage } from "../../../lib/types";

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !supabaseKey) {
  throw new Error("Missing Supabase environment variables");
}

const supabase = createClient(supabaseUrl, supabaseKey);

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method === "POST") {
    fetchPollsInternal(req, res);
  } else {
    res.setHeader("Allow", ["POST"]);
    res.status(405).end(`Method ${req.method} Not Allowed`);
  }
}


export async function fetchPollsInternal(
  request: NextApiRequest,
  res: NextApiResponse
) {

  try {
    console.log("fetchPollsInternal", request.body);
    const { signature, ephemeralPubkey, ephemeralPubkeyExpiry, signedMessageFormatted, country, groupId } = request.body;
    console.log("groupId", groupId);
    console.log("country", country);
    const limit = parseInt(request.query?.limit as string) || 50;
    const afterTimestamp = request.query?.afterTimestamp as string;
    const beforeTimestamp = request.query?.beforeTimestamp as string;
    const parentId = request.query?.parentId as string;

    let query = supabase
      .from("polls")
      .select(`
        id,
        title,
        description,
        is_yes_no,
        answer_options,
        max_options,
        min_options,
        multiselect,
        created_at,
        ends_at,
        creator_pubkey,
        is_show_results_publicly,
        is_only_organizations,
        is_only_kyc_verified,
        age_required,
        is_specific_countries,
        nationality,
        date_of_birth,
        gender,
        organization_name,
        pubkey,
        group_id,
        group_provider,
        selected_countries,
        selected_organizations
      `)
      .order("created_at", { ascending: false })
      .eq("internal", true)
      .limit(limit);


    const signedMessage = {
      ...signedMessageFormatted,
      signature: BigInt(signature),
      ephemeralPubkey: BigInt(ephemeralPubkey),
      timestamp: new Date(signedMessageFormatted?.timestamp),
    }

    console.log("signedMessage", signedMessage);

    if (signedMessage?.ephemeralPubkeyExpiry < new Date()) {
      throw new Error("Ephemeral pubkey expired");
    }

    const isValid = await verifyMessageSignature(signedMessage);
    if (!isValid) {
      throw new Error("Message signature check failed");
    }

    if (signedMessage?.ephemeralPubkey != BigInt(ephemeralPubkey)) {
      throw new Error("Ephemeral pubkey mismatch");
    }

    const isInternal = true;
    const authHeader = request.headers.authorization;
    console.log("authHeader", authHeader);
    const pubkey = authHeader?.split(" ")[1];

    if (!pubkey) {
      throw new Error("Authorization required for internal polls");
    }
    if (pubkey && signedMessage?.ephemeralPubkey != BigInt(pubkey)) {
      throw new Error("Ephemeral pubkey mismatch");
    }

    // query = query.eq("internal", !!isInternal);


    // if (parentId) {
    //   query = query.eq("parent_id", parentId);
    // } else {
    //   query = query.is("parent_id", null);
    // }

    // if (afterTimestamp) {
    //   query = query.gt("timestamp", new Date(Number(afterTimestamp)).toISOString());
    // }

    // if (beforeTimestamp) {
    //   query = query.lt("timestamp", new Date(Number(beforeTimestamp)).toISOString());
    // }

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res
        .status(401)
        .json({ error: "Authorization required for internal messages" });
    }


    // Internal messages require a valid pubkey from the same group (as Authorization header)
    if (isInternal) {
      if (!groupId) {
        return res
          .status(400)
          .json({ error: "Group ID is required for internal messages" });
      }


    }

    if (country && typeof country === 'string' && country.length > 0 && typeof country != 'undefined') {
      // Using the ANY operator to check if the country exists in the selected_countries array
      const { data: passportRegistrationData, error: passportRegistrationError } = await supabase
        .from("passport_registrations")
        .select("*")
        .eq("pubkey", pubkey)
        .eq("nationality", country)
        .single();

      console.log("passportRegistrationData", passportRegistrationData?.pubkey);
      console.log("passportRegistrationError", passportRegistrationError);
      if (passportRegistrationError || !passportRegistrationData) {
        return res.status(401).json({ error: "Invalid public key for this nationality" });
      }

      query = query.filter('selected_countries', 'cs', `{${country}}`);
    }

    if (groupId) {
      console.log("groupId", groupId);


      if (country) {
        // Using the ANY operator to check if the country exists in the selected_countries array
        query = query.filter('selected_organizations', 'cs', `{${groupId}}`);
        // query = query.filter('selected_countries', 'cs', `{${country}}`);
      }
      // query = query.eq("group_id", groupId);

      const pubkey = authHeader.split(" ")[1];
      const { data: membershipData, error: membershipError } = await supabase
        .from("memberships")
        .select("*")
        .eq("pubkey", pubkey)
        .eq("group_id", groupId)
        .single();

      console.log("membershipData", membershipData?.pubkey);
      if (membershipError || !membershipData) {
        return res.status(401).json({ error: "Invalid public key for this group" });
      }
    }
    const { data, error } = await query;

    console.log("data", data);

    if (error) {
      console.error(error);
      return res.status(500).json({ error: error.message });
    }

    return res.json(data);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: (error as Error)?.message });
  }
}
