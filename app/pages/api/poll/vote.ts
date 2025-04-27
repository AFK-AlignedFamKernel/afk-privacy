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
    voteToReview(req, res);
  } else {
    res.setHeader("Allow", ["POST"]);
    res.status(405).end(`Method ${req.method} Not Allowed`);
  }
}

export async function voteToReview(
  request: NextApiRequest,
  res: NextApiResponse
) {
  try {
    const body = await request.body;
    const { pollId, option, signedMessage } = body;


    console.log("voteToReview body", body);

    const signedMessageFormatted = {
      ...signedMessage,
      ephemeralPubkey: BigInt(signedMessage.ephemeralPubkey),
      ephemeralPubkeyExpiry: new Date(signedMessage.ephemeralPubkeyExpiry),
      signature: BigInt(signedMessage.signature),
      timestamp: new Date(signedMessage.timestamp),
    }

    console.log("voteToReview signedMessageFormatted", signedMessageFormatted);
    // Verify the signed message
    const isValid = await verifyMessageSignature(signedMessageFormatted);
    if (!isValid) {
      throw new Error("Invalid message signature");
    }

    // Get the poll details
    const { data: poll, error: pollError } = await supabase
      .from("polls")
      .select("*")
      .eq("id", pollId)
      .single();

    if (pollError || !poll) {
      throw new Error("Poll not found");
    }

    // Check if poll is still active
    if (new Date(poll.ends_at) < new Date()) {
      throw new Error("Poll has ended");
    }

    // Get voter's membership and passport data
    const { data: ephemeralKey, error: ephemeralKeyError } = await supabase
      .from("ephemeral_keys")
      .select("*")
      .eq("pubkey", signedMessageFormatted.ephemeralPubkey.toString())
      .single();

    if (ephemeralKeyError || !ephemeralKey) {
      throw new Error("Voter is not a member");
    }

    // Get voter's membership and passport data
    const { data: membership, error: membershipError } = await supabase
      .from("memberships")
      .select("*")
      .eq("pubkey", signedMessageFormatted.ephemeralPubkey.toString())
      .single();
    console.log("pollId", pollId);
    console.log("poll", poll);


    // Check KYC requirements if needed
    if (poll.is_only_kyc_verified) {
      const { data: passport, error: passportError } = await supabase
        .from("passport_registrations")
        .select("*")
        .eq("pubkey", signedMessage.ephemeralPubkey.toString())
        .single();

      if (passportError || !passport) {
        throw new Error("KYC verification required to vote in this poll");
      }
    }

    // Check organization requirements if needed
    if (poll?.is_only_organizations) {
      // if (!membership) {
      //   throw new Error("Only organizations can vote in this poll");
      // }
    }

    // Check if user has already voted
    const { data: existingVote, error: voteError } = await supabase
      .from("poll_votes")
      .select("*")
      .eq("poll_id", pollId)
      .eq("voter_pubkey", signedMessage.ephemeralPubkey.toString())
      .single();

    if (voteError && voteError.code !== "PGRST116") { // PGRST116 is "not found" error
      throw voteError;
    }

    if (existingVote) {
      throw new Error("You have already voted in this poll");
    }

    // Get the option ID
    const { data: pollOption, error: optionError } = await supabase
      .from("poll_options")
      .select("id, option_text, poll_id, poll_option_id")
      .eq("poll_id", pollId)
      .eq("option_text", option)
      .single();
    console.log("voteToReview pollOption", pollOption);

    if (optionError || !pollOption) {
      // throw new Error("Invalid poll option");
    }

    console.log("pollOption", pollOption);
    // Create the vote
    const { error: insertError } = await supabase.from("poll_votes").insert([
      {
        poll_id: pollId,
        option_id: pollOption?.id,
        voter_pubkey: signedMessage.ephemeralPubkey.toString(),
        group_id: poll.group_id,
        group_provider: poll.group_provider,
        membership_id: membership?.id,
        passport_registration_id: poll.is_only_kyc_verified ? membership.passport_registration_id : null
      }
    ]);

    if (insertError) {
      throw insertError;
    }

    // Return updated poll stats
    const { data: updatedStats, error: statsError } = await supabase
      .from("poll_stats")
      .select("*")
      .eq("poll_id", pollId);

    if (statsError) {
      throw statsError;
    }

    res.status(200).json(updatedStats);
  } catch (error) {
    console.error("Error voting:", error);
    res.status(500).json({ error: (error as Error).message });
  }
}

export async function fetchMessagesCountry(
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
    .from("country_messages")
    .select(
      "id, text, timestamp, signature, pubkey, internal, likes, reply_count, group_id, group_provider, parent_id, nationality, gender, date_of_birth"
    )
    .order("timestamp", { ascending: false })
    .limit(limit);

  query = query.eq("internal", !!isInternal);

  if (groupId) {
    // query = query.eq("group_id", groupId);
    query = query.eq("nationality", groupId);
  }

  if (parentId) {
    query = query.eq("parent_id", parentId);
  } else {
    query = query.is("parent_id", null);
  }

  if (afterTimestamp) {
    query = query.gt("timestamp", new Date(Number(afterTimestamp)).toISOString());
  }

  if (beforeTimestamp) {
    query = query.lt("timestamp", new Date(Number(beforeTimestamp)).toISOString());
  }

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
      .from("memberships")
      .select("*")
      .eq("pubkey", pubkey)
      .eq("group_id", groupId)
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

  const messages: Partial<SignedMessage>[] = data.map((message) => ({
    id: message.id,
    anonGroupId: message.group_id,
    anonGroupProvider: message.group_provider,
    text: message.text,
    timestamp: message.timestamp,
    signature: message.signature,
    ephemeralPubkey: message.pubkey,
    internal: message.internal,
    likes: message.likes,
    replyCount: message.reply_count,
    parentId: message.parent_id,
    nationality: message.nationality,
    gender: message.gender,
    dateOfBirth: message.date_of_birth
  }));

  res.json(messages);
  res.end();
}
