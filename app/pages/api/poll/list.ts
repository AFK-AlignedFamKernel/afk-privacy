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
  if (req.method === "GET") {
    fetchPolls(req, res);
  } else {
    res.setHeader("Allow", ["GET", "POST"]);
    res.status(405).end(`Method ${req.method} Not Allowed`);
  }
}


export async function fetchPolls(
  request: NextApiRequest,
  res: NextApiResponse
) {
  const groupId = request.query?.groupId as string;
  const isInternal = request.query?.isInternal === "true";
  const limit = parseInt(request.query?.limit as string) || 50;
  const afterTimestamp = request.query?.afterTimestamp as string;
  const beforeTimestamp = request.query?.beforeTimestamp as string;
  const parentId = request.query?.parentId as string;

  let query = supabase
    .from("polls")
    .select(
      "id, title, description, pubkey, is_yes_no, answer_options, max_options, min_options, multiselect, ends_at, show_results_publicly, is_only_organizations, is_only_kyc_verified, age_required, is_specific_countries, countries_accepted, countries_excluded, passport_registration_id"
      // "id, title, about, timestamp, group_id, group_provider, pubkey, is_yes_no, answer_options, max_options, min_options, multiselect, ends_at, show_results_publicly, is_only_organizations, is_only_kyc_verified, age_required, is_specific_countries, countries_accepted, countries_excluded, passport_registration_id"
    )
    .order("created_at", { ascending: false })
    .limit(limit);

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

  // Internal messages require a valid pubkey from the same group (as Authorization header)
  if (isInternal) {
    if (!groupId) {
      res
        .status(400)
        .json({ error: "Group ID is required for internal messages" });
      res.end();
      return;
    }

    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      res
        .status(401)
        .json({ error: "Authorization required for internal messages" });
      res.end();
      return;
    }

    const pubkey = authHeader.split(" ")[1];
    const { data: membershipData, error: membershipError } = await supabase
      .from("ephemeral_keys")
      .select("*")
      .eq("pubkey", pubkey)
      // .eq("group_id", groupId)
      .single();

    if (membershipError || !membershipData) {
      res.status(401).json({ error: "Invalid public key for this group" });
      res.end();
      return;
    }
  }

  const { data, error } = await query;

  if (error) {
    console.error(error);
    res.status(500).json({ error: error.message });
    res.end();
    return;
  }

  // const messages: Partial<SignedMessage>[] = data.map((message) => ({
  //   id: message.id,
  //   anonGroupId: message.group_id,
  //   anonGroupProvider: message.group_provider,
  //   text: message.text,
  //   timestamp: message.timestamp,

  // }));

  // res.json(messages);
  res.json(data);
  res.end();
}
