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

    if (!pollId) {
      throw new Error("Poll ID is required");
    }

    if (!option) {
      throw new Error("Option is required");
    }

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


    const { data: passport, error: passportError } = await supabase
      .from("passport_registrations")
      .select("*")
      .eq("pubkey", signedMessage.ephemeralPubkey.toString())
      .single();

    console.log("passport", passport);
    // Check KYC requirements if needed
    if (poll.is_only_kyc_verified) {

      if (passportError || !passport) {
        throw new Error("KYC verification required to vote in this poll");
      }
    }

    // Check organization requirements if needed
    if (poll?.is_only_organizations) {
      // if (!membership) {
      //   throw new Error("Only organizations can vote in this poll");
      // }
      if (poll?.selected_organizations && poll?.selected_organizations?.length > 0) {
        if (!membership?.anon_group_id || !poll?.selected_organizations?.includes(membership?.anon_group_id)) {
          throw new Error("You are not a member of an organization that can vote in this poll");
        }
      }
    }

    // Check country requirements if needed

    // Todo add check
    if (poll?.selected_countries && poll?.selected_countries?.length > 0) {
      console.log("poll?.selected_countries", poll?.selected_countries);
      // const { data: passport, error: passportError } = await supabase
      //   .from("passport_registrations")
      //   .select("*")
      //   .eq("pubkey", signedMessage.ephemeralPubkey.toString())
      //   .single();

      if (passportError || !passport) {
        throw new Error("Passport verification required to vote in this poll");
      }

      // Check if user's country is in accepted countries list
      if (poll.countries_accepted && poll.countries_accepted.length > 0) {
        if (!passport.country || !poll.countries_accepted.includes(passport.country)) {
          throw new Error("Your country is not eligible to vote in this poll");
        }
      }

      // Check if user's country is in excluded countries list
      if (poll.countries_excluded && poll.countries_excluded.length > 0) {
        if (passport.nationality && poll.countries_excluded.includes(passport.nationality)) {
          throw new Error("Your country is excluded from voting in this poll");
        }
      }

      const nationality = passport?.nationality;
      const isNationalityEligible = poll.selected_countries?.find((country: string) => country === nationality);
      // Check if user's country is in excluded countries list
      if (poll.selected_countries && poll.selected_countries.length > 0) {
        if (!passport.nationality) {
          throw new Error("Your nationality is not eligible to vote in this poll");
        }
        if (!poll.selected_countries.includes(passport?.nationality) || !isNationalityEligible) {
          throw new Error("Your nationality is not eligible to vote in this poll");
        }
      }
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
    console.log("option", option);
    console.log("pollId", pollId);
    const { data: pollOption, error: optionError } = await supabase
      .from("poll_options")
      .select("id, option_text, poll_id")
      .eq("poll_id", pollId)
      .eq("option_text", option)
      .single();
    console.log("voteToReview pollOption", pollOption);
    console.log("optionError", optionError);

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
