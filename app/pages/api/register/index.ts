import type { NextApiRequest, NextApiResponse } from "next";
import { createClient } from "@supabase/supabase-js";
import { verifyMessageSignature } from "../../../lib/ephemeral-key";
import { SignedMessage } from "../../../lib/types";
import { ZKPassport } from "@zkpassport/sdk";

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
        // fetchMessages(req, res);
    } else if (req.method === "POST") {
        registerIdentity(req, res);
    } else {
        res.setHeader("Allow", ["GET", "POST"]);
        res.status(405).end(`Method ${req.method} Not Allowed`);
    }
}

async function registerIdentity(req: NextApiRequest, res: NextApiResponse) {
 
    try {
        const { email, password, proofs, queryResult, verification } = req.body;

        const { data, error } = await supabase
            .from("memberships")
            .insert({ email, password, proofs, queryResult });
    
    
        if (!verification || !verification.proofs || !verification.queryResult) {
            return res.status(400).json({
                success: false,
                error: "Missing ZKPassport verification data",
            });
        }
    
        const zkPassport = new ZKPassport("your-domain.com");
    
        // Verify the proofs
        const { verified, queryResultErrors, uniqueIdentifier } = await zkPassport.verify({
            proofs: verification.proofs,
            queryResult: verification.queryResult,
        });
    
        if (!verified) {
            console.error("Verification failed:", queryResultErrors);
            return res.status(400).json({
                success: false,
                error: "Identity verification failed",
            });
        }
    
        if (!uniqueIdentifier) {
            return res.status(400).json({
                success: false,
                error: "Could not extract the unique identifier",
            });
        }
    
        // Extract any disclosed information
        console.log("query result", verification.queryResult);

        const nationality = verification.queryResult.nationality?.disclose?.result;
        const age = verification.queryResult.age?.disclose?.result;
        const gender = verification.queryResult.gender?.disclose?.result;
    
        // Create a user in your database with the uniqueIdentifier
        const user = await createUser({
            email,
            password, // Remember to hash this password!
            id: uniqueIdentifier,
            nationality: nationality || null,
            age: age || null,
            pubkey: uniqueIdentifier,
            gender: gender || null,
            // Add other registration fields as needed
        });
    
        return res.status(200).json({
            success: true,
            message: "User created successfully",
            data: user,
        }); 
    } catch (error) {
        console.error(error);
        return res.status(500).json({
            success: false,
            error: "Internal server error",
        });
    }


}

export async function createUser({ email, password, id, nationality,
    pubkey,
    age,
    gender
 }: { email: string, password: string, id: string, nationality: string | null, pubkey: string, age?: number, gender?: string }) {
    // const { data, error } = await supabase
    //     .from("users")
    //     .insert({ email, password, id, nationality });
    const { data, error } = await supabase
        .from("residents")
        .insert({ 
            // email, password, 
            id,
            pubkey,
            nationality: nationality || null,
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString(),
            age: age || null,
            gender: gender || null,
        });
    if (error) {
        throw new Error(error.message);
    }

    return data;
}       