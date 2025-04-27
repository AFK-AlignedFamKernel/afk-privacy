import type { NextApiRequest, NextApiResponse } from "next";
import { createClient } from "@supabase/supabase-js";
import { SignedMessageWithProof } from "../../../../../lib/types";

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
        internal,
        parent_id,
        ephemeral_key_id
      `)
      .eq("id", id)
      .single();

    if (error) {
      throw error;
    }

    const { data: ephemeralData, error: ephemeralError } = await supabase
      .from("ephemeral_memberships")
      .select("*")
      .eq("pubkey", data.pubkey)
      // .eq("group_id", data.group_id)
      .single();


    const { data: passportCreation, error: passportCreationError } = await supabase
      .from("passport_registrations")
      .select("*")
      .eq("pubkey", data.pubkey)
      // .eq("group_id", data.group_id)
      .single();
    if (!data) {
      res.status(404).json({ error: "Message not found" });
      res.end();
      return;
    }

    if (data.internal) {
      const authHeader = req.headers.authorization;
      if (!authHeader || !authHeader.startsWith("Bearer ")) {
        res
          .status(401)
          .json({ error: "Authorization required for internal messages" });
        res.end();
        return;
      }

      // fix todo
      // const pubkey = authHeader.split(" ")[1];
      // const { data: myMembership, error: myMembershipError } = await supabase
      //   .from("memberships")
      //   .select("*")
      //   .eq("pubkey", pubkey)
      //   .eq("group_id", data.group_id)
      //   .single();

      // if (myMembershipError || !myMembership) {
      //   res.status(401).json({ error: "Invalid public key for this group" });
      //   res.end();
      //   return;
      // }
    }

    console.log("data", data);

    console.log("passportCreation", passportCreation);

    const message: SignedMessageWithProof = {
      id: data.id,
      anonGroupId: data.group_id,
      anonGroupProvider: data.group_provider,
      text: data.text,
      timestamp: data.timestamp,
      signature: data.signature,
      ephemeralPubkey: data.pubkey,
      ephemeralPubkeyExpiry: passportCreation?.pubkey_expiry,
      internal: data.internal,
      likes: data.likes,
      replyCount: data.reply_count,
      parentId: data.parent_id,
      proof: JSON.parse(JSON.stringify(passportCreation?.proof)),
      proofArgs: JSON.parse(JSON.stringify(passportCreation?.proof_args)),
      proofString: JSON.stringify(passportCreation?.proof),
      proofArgsString: JSON.stringify(passportCreation?.proof_args),
    };

    res.json(message);
    res.end();
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal server error" });
    res.end();
  }
}
