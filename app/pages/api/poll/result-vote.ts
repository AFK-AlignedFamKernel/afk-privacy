import type { NextApiRequest, NextApiResponse } from "next";
import { createClient } from "@supabase/supabase-js";
import { verifyMessageSignature } from "../../../lib/ephemeral-key";
import { SignedMessage } from "../../../lib/types";
import { PollStats } from "@/lib/types/poll";

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
    fetchResultVote(req, res);
  } else {
    res.setHeader("Allow", ["POST"]);
    res.status(405).end(`Method ${req.method} Not Allowed`);
  }
}

export async function fetchResultVote(
  request: NextApiRequest,
  res: NextApiResponse
) {
  try {
    const body = await request.body;
    const { pollId, option, signedMessage } = body;


    console.log("fetchResultVote body", body);

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
    // const { data: poll, error: pollError } = await supabase
    //   .from("polls")
    //   .select("*")
    //   .eq("id", pollId)
    //   .single();

    const { data: poll, error: pollError } = await supabase
      .from('polls')
      .select(`
      id,
      title,
      description,
      total_votes,
      total_kyc_votes,
      total_org_votes,
      is_show_results_publicly,
      ends_at,
      pubkey,
      options:poll_options(
        id,
        option_text,
        vote_count
      )
    `)
      .eq('id', pollId)
      .single();

    const owner = poll?.pubkey;

    console.log("owner", owner);

    const isPublicResult = poll?.is_show_results_publicly;

    if (pollError || !poll) {
      throw new Error("Poll not found");
    }

    if (!isPublicResult && owner !== signedMessageFormatted.ephemeralPubkey.toString()) {
      throw new Error("Poll is not public");
    }

    // Get voter's membership and passport data
    const { data: ephemeralKey, error: ephemeralKeyError } = await supabase
      .from("ephemeral_keys")
      .select("*")
      .eq("pubkey", signedMessageFormatted.ephemeralPubkey.toString())
      .single();

    // if (ephemeralKeyError || !ephemeralKey) {
    //   throw new Error("Voter is not a member");
    // }

    if (!isPublicResult && owner !== ephemeralKey.pubkey) {
      throw new Error("Not the correct owner of the poll");
    }

    // Get voter's membership and passport data
    const { data: membership, error: membershipError } = await supabase
      .from("memberships")
      .select("*")
      .eq("pubkey", signedMessageFormatted.ephemeralPubkey.toString())
      .single();
    console.log("pollId", pollId);
    console.log("poll", poll);

    // const { data: passport, error: passportError } = await supabase
    //   .from("passport_registrations")
    //   .select("*")
    //   .eq("pubkey", signedMessage.ephemeralPubkey.toString())
    //   .single();

    // console.log("passport", passport);

    // Check if user has already voted
    const { data: existingVote, error: voteError } = await supabase
      .from("poll_votes")
      .select("*")
      .eq("poll_id", pollId)
      .eq("voter_pubkey", signedMessage.ephemeralPubkey.toString())
      .single();

    // Get the option ID
    const { data: pollOption, error: optionError } = await supabase
      .from("poll_options")
      .select("id, option_text, poll_id, poll_option_id")
      .eq("poll_id", pollId)
      .eq("option_text", option)
      .single();
    console.log("voteToReview pollOption", pollOption);


    console.log("pollOption", pollOption);



    // Return updated poll stats with optimized query
    const { data: pollStats, error: statsError } = await supabase
      .from('polls')
      .select(`
        id,
        title,
        total_votes,
        total_kyc_votes,
        total_org_votes,
        options:poll_options(
          id,
          option_text,
          vote_count,
          poll_votes:poll_votes!poll_votes_option_id_fkey(
            is_kyc_vote,
            is_organization_vote
          )
        )
      `)
      .eq('id', pollId)
      .single();

    if (statsError) {
      throw statsError;
    }

    // Get total votes count
    const { count: totalPollVotes } = await supabase
      .from('poll_votes')
      .select('*', { count: 'exact', head: true })
      .eq('poll_id', pollId);

    // Get votes by country in a separate query
    const { data: countryVotes } = await supabase
      .from('poll_votes')
      .select('nationality')
      .eq('poll_id', pollId);

    // Process the results
    const processedStats: PollStats = {
      ...pollStats,
      total_poll_votes: pollStats.total_votes || totalPollVotes || 0,
      // total_poll_votes: totalPollVotes || 0,
      votes_by_country: (countryVotes || []).reduce((acc: Record<string, number>, curr: { nationality: string | null }) => {
        const country = curr.nationality || 'unknown';
        acc[country] = (acc[country] || 0) + 1;
        return acc;
      }, {})
    };

    // Process options to get filtered counts
    processedStats.options = processedStats.options.map(option => ({
      ...option,
      kyc_votes: option.poll_votes?.filter(vote => vote.is_kyc_vote).length || 0,
      org_votes: option.poll_votes?.filter(vote => vote.is_organization_vote).length || 0
    }));

    console.log("processedStats", processedStats);

    res.status(200).json(processedStats);
  } catch (error) {
    console.error("Error voting:", error);
    res.status(500).json({ error: (error as Error).message });
  }
}
