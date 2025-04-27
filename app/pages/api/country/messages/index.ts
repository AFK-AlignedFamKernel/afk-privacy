import type { NextApiRequest, NextApiResponse } from "next";
import { createClient } from "@supabase/supabase-js";
import { verifyMessageSignature } from "../../../../lib/ephemeral-key";
import { SignedMessage } from "../../../../lib/types";

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
    postMessageCountry(req, res);
  } else {
    res.setHeader("Allow", ["GET", "POST"]);
    res.status(405).end(`Method ${req.method} Not Allowed`);
  }
}

export async function postMessageCountry(
  request: NextApiRequest,
  res: NextApiResponse
) {
  try {
    const body = (await request.body);

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

    // Verify pubkey is registered
    const { data, error } = await supabase
      .from("ephemeral_keys")
      .select("*")
      .eq("pubkey", signedMessage.ephemeralPubkey.toString())
      // .eq("group_id", signedMessage.anonGroupId)
      // .eq("provider", signedMessage.anonGroupProvider)
      .single();

    if (error) {
      throw error;
    }

    if (!data.pubkey) {
      throw new Error("Pubkey not registered");
    }

    if (signedMessage.ephemeralPubkeyExpiry < new Date()) {
      throw new Error("Ephemeral pubkey expired");
    }

    const isValid = await verifyMessageSignature(signedMessage);
    if (!isValid) {
      throw new Error("Message signature check failed");
    }


    const { data: passportData, error: passportError } = await supabase.from("passport_registrations").select("*").eq("pubkey", signedMessage.ephemeralPubkey.toString()).single();


    if (!passportData || passportError) {
      console.error("Passport data not found", passportError);
      throw new Error("Passport data not found");
    }
    const nationality = passportData?.nationality;
    const gender = passportData?.gender;
    const dateOfBirth = passportData?.date_of_birth;

    if(!passportData?.nationality || typeof passportData?.nationality !== "string") {    
      throw new Error("Passport data not found");
    }

    if(passportData?.nationality?.length <= 2) {
      throw new Error("Invalid nationality");
    }

    if(!passportData?.is_verified) {
      throw new Error("Passport not verified");
    }

    const { error: insertError } = await supabase.from("country_messages").insert([
      {
        id: signedMessage.id,
        group_id: signedMessage.anonGroupId,
        group_provider: signedMessage.anonGroupProvider,
        text: signedMessage.text,
        timestamp: signedMessage.timestamp.toISOString(),
        signature: signedMessage.signature.toString(),
        pubkey: signedMessage.ephemeralPubkey.toString(),
        internal: signedMessage.internal,
        parent_id: signedMessage?.parentId,
        reply_count: 0,
        nationality: nationality,
        // gender: gender,
        // date_of_birth: dateOfBirth,
      },
    ]);

    if (insertError) {
      throw insertError;
    }

    // Return the created message
    const { data: createdMessage, error: fetchError } = await supabase
      .from("country_messages")
      .select(`
        id,
        group_id,
        group_provider,
        text,
        timestamp,
        signature,
        pubkey,
        internal,
        likes,
        reply_count,
        parent_id,
        nationality,
        gender,
        date_of_birth

      `)
      .eq("id", signedMessage.id)
      .single();

    if (fetchError) {
      throw fetchError;
    }

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
    // gender: message.gender,
    // dateOfBirth: message.date_of_birth
  }));

  res.json(messages);
  res.end();
}
