import type { NextApiRequest, NextApiResponse } from "next";
import { createClient } from "@supabase/supabase-js";
import { SignedMessageWithProof } from "../../../lib/types";

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
    getSingleMessage(req, res);
  } else {
    res.setHeader("Allow", ["GET"]);
    res.status(405).end(`Method ${req.method} Not Allowed`);
  }
}

async function getSingleMessage(req: NextApiRequest, res: NextApiResponse) {
  try {
    const { id } = req.query;

    if (!id) {
      res.status(400).json({ error: "Message ID is required" });
      res.end();
      return;
    }

    const { data, error } = await supabase
      .from("messages")
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
        memberships!fk_message_membership (
          proof,
          pubkey_expiry,
          proof_args
        )
      `)
      .eq("id", id)
      .single();

    if (error) {
      throw error;
    }

    if (!data) {
      res.status(404).json({ error: "Message not found" });
      res.end();
      return;
    }
    const authHeader = req.headers.authorization;
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
      .eq("group_id", data.group_id)
      .single();

    if (membershipError || !membershipData) {
      res.status(401).json({ error: "Invalid public key for this group" });
      res.end();
      return;
    }

    // TODO add check verification
    if (data.internal) {
  
    }

    const message: SignedMessageWithProof = {
      id: data.id,
      anonGroupId: data.group_id,
      anonGroupProvider: data.group_provider,
      text: data.text,
      timestamp: data.timestamp,
      signature: data.signature,
      ephemeralPubkey: data.pubkey,
      ephemeralPubkeyExpiry: membershipData.pubkey_expiry,
      internal: data.internal,
      likes: data.likes,
      replyCount: data.reply_count,
      parentId: data.parent_id,
      proof: JSON.parse(membershipData.proof),
      proofArgs: JSON.parse(membershipData.proof_args),
    };

    res.json(message);
    res.end();
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal server error" });
    res.end();
  }
}
