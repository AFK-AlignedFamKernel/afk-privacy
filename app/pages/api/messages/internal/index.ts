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
  if (req.method === "POST") {
    fetchInternalMessages(req, res);
  } else {
    res.setHeader("Allow", ["POST"]);
    res.status(405).end(`Method ${req.method} Not Allowed`);
  }
}


export async function fetchInternalMessages(
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
    .from("messages")
    .select(
      "id, text, timestamp, signature, pubkey, internal, likes, reply_count, group_id, group_provider, parent_id, image_url, video_url"
    )
    .order("timestamp", { ascending: false })
    .limit(limit);

  // query = query.eq("internal", !!isInternal);

  if (groupId) {
    query = query.eq("group_id", groupId);
  }
  
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
    query = query.eq("internal", true);
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

    // console.log("membershipData", membershipData);
    if (membershipError || !membershipData) {
      res.status(401).json({ error: "Invalid public key for this group" });
      res.end();
      return;
    }
  }

  const { data, error } = await query;

  console.log("data", data);
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
    imageUrl: message.image_url,
    videoUrl: message.video_url
  }));
  console.log("messages", messages);

  res.json(messages);
  res.end();
}
