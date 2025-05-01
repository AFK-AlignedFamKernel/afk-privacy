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
    fetchOrganizations(req, res);
  } else {
    res.setHeader("Allow", ["GET", "POST"]);
    res.status(405).end(`Method ${req.method} Not Allowed`);
  }
}


export async function fetchOrganizations(
  request: NextApiRequest,
  res: NextApiResponse
) {
  try {
    const pollId = request.query?.pollId as string;

    const isInternal = request.query?.isInternal === "true";
    const query = supabase
      .from("organizations")
      .select(`
      *
    `)
      .order("created_at", { ascending: false })


    const { data, error } = await query;

    console.log("data", data);

    if (error) {
      console.error(error);
      res.status(500).json({ error: error.message });
      res.end();
      return;
    }

    res.json(data);
    res.end();
  } catch (error) {
    console.log("error fetching poll", error)
    return res.json({ error: "Error fetching poll" })
  }
}
