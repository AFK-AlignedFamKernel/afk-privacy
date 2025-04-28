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
    fetchMessagesCountry(req, res);
  } else if (req.method === "POST") {
    createReview(req, res);
  } else {
    res.setHeader("Allow", ["GET", "POST"]);
    res.status(405).end(`Method ${req.method} Not Allowed`);
  }
}

export async function createReview(
  request: NextApiRequest,
  res: NextApiResponse
) {
  try {
    const body = (await request.body);

    console.log("createReview body", body);

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
    console.log("createReview signedMessage", signedMessage);
    const reviewData = {
      // is_yes_no: body.isYesNo,
      max_options: body.max_options,
      min_options: body.min_options,
      answer_options: body.answer_options,
      multiselect: body.multiselect,
      creator_pubkey: signedMessage.ephemeralPubkey.toString(),
      title: body.title,
      description: body.description,
      ends_at: new Date(body.ends_at),
      is_show_results_publicly: body.is_show_results_publicly ?? false,
      group_id: signedMessage.anonGroupId,
      group_provider: signedMessage.anonGroupProvider,
      selected_organizations: body.selected_organizations,
      selected_countries: body.selected_countries,
      is_only_organizations: body.is_only_organizations,
      is_only_kyc_verified: body.is_only_kyc_verified,
      pubkey: signedMessage.ephemeralPubkey.toString(),

    }
    console.log("createReview reviewData", reviewData);



    // Verify pubkey is registered and check membership
    const { data, error } = await supabase
      .from("ephemeral_keys")
      .select(`
        *`)
      .eq("pubkey", signedMessage?.ephemeralPubkey?.toString())
      .single();



    // const authHeader = request.headers.authorization;
    // if (!authHeader || !authHeader.startsWith("Bearer ")) {
    //   res.status(401).json({ error: "Authorization required for internal messages" });
    //   res.end();
    //   return;
    // }

    // if (error) {
    //   throw error;
    // }


    let ephemeralData: any;
    if (!data?.pubkey || error) {
      console.log("Ephemeral data not found, creating new ephemeral key");
      const { data: ephemeralDataResult , error: ephemeralError } = await supabase.from("ephemeral_keys").upsert({
        pubkey: signedMessage?.ephemeralPubkey?.toString(),
        // ephemeralPubkeyExpiry: signedMessage?.ephemeralPubkeyExpiry,
        // salt: signedMessage.ephemeralPubkeySalt,
        signature: signedMessage?.signature?.toString(),
      }).select("*").single();
      ephemeralData = ephemeralDataResult;
      if (!ephemeralDataResult || ephemeralError) {
        console.error("Ephemeral data not found", ephemeralError);
        throw new Error("Pubkey not registered");
      }
    }

    if (signedMessage.ephemeralPubkeyExpiry < new Date()) {
      throw new Error("Ephemeral pubkey expired");
    }

    const isValid = await verifyMessageSignature(signedMessage);
    if (!isValid) {
      throw new Error("Message signature check failed");
    }


    const { data: passportData, error: passportError } = await supabase.from("passport_registrations").select("*").eq("pubkey", signedMessage.ephemeralPubkey.toString()).single();


    // if (!passportData || passportError) {
    //   console.error("Passport data not found", passportError);
    //   throw new Error("Passport data not found");
    // }

    // if(!passportData?.nationality || typeof passportData?.nationality !== "string" || passportData?.nationality?.length !== 2) {
    //   throw new Error("Invalid nationality");
    // }
    const nationality = passportData?.nationality;
    const gender = passportData?.gender;
    const dateOfBirth = passportData?.date_of_birth;
    const { error: insertError, data: createdPoll } = await supabase.from("polls").insert([
      {
        id: signedMessage.id,
        // text: signedMessage.text,
        // timestamp: signedMessage.timestamp.toISOString(),
        // signature: signedMessage.signature.toString(),
        // pubkey: signedMessage.ephemeralPubkey.toString(),
        // internal: signedMessage.internal,
        // parent_id: signedMessage?.parentId,
        ...reviewData
      },
    ]);

    if (insertError) {
      throw insertError;
    }

    // Return the created message
    const { data: createdMessage, error: fetchError } = await supabase
      .from("polls")
      .select(`*, poll_options(*)`)
      .eq("id", signedMessage.id)
      .single();

    if (fetchError) {
      throw fetchError;
    }


    const pollOptionsToInsert = body.answer_options?.map((option: string) => ({
      poll_id: signedMessage.id,
      option_text: option,
    }));

    const { data: createdPollOptions, error: createPollOptionsError } = await supabase
      .from("poll_options")
      .insert(pollOptionsToInsert);


    console.log("createdMessage", createdMessage);
    res.status(201).json(createdMessage);
    res.end();
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: (error as Error).message });
    res.end();
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
