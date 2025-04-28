import type { NextApiRequest, NextApiResponse } from "next";
import { createClient } from "@supabase/supabase-js";
// import { ZKPassport } from "@zkpassport/sdk";
import { ZKPassport } from '@zkpassport/sdk/dist/esm/index.js';
import { verifyMessageSignature } from "@/lib/ephemeral-key";

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

        console.log("registerIdentity", req.body);
        const { proofs, queryResult, verification, signedMessage } = req.body;



        if (!verification || !verification.proofs || !verification.queryResult) {
            return res.status(400).json({
                success: false,
                error: "Missing ZKPassport verification data",
            });
        }

        if (!signedMessage) {
            return res.status(400).json({
                success: false,
                error: "Missing signed message",
            });
        }

        const { uuid, pubkey } = signedMessage;

        if (!uuid || !pubkey) {
            return res.status(400).json({ message: 'UUID, pubkey and signAsync are required' });
        }

        const signedMessageFormated = {
            ...signedMessage,
            ephemeralPubkey: BigInt(signedMessage.ephemeralPubkey),
            signature: BigInt(signedMessage.signature),
            timestamp: new Date(signedMessage?.timestamp),
        }


        const isValid = await verifyMessageSignature(signedMessageFormated);
        console.log("isValid:", isValid);
        if (!isValid) {
            throw new Error("Message signature check failed");
        }

        const domainUrl = process.env.ZKPASSPORT_DOMAIN_URL || "http://localhost:3000";

        console.log("domainUrl:", domainUrl);
        const zkPassport = new ZKPassport(domainUrl);

        // Verify the proofs
        const { verified, queryResultErrors, uniqueIdentifier } = await zkPassport.verify({
            proofs: verification.proofs,
            queryResult: verification.queryResult,
        });

        console.log("verified", verified);

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



        // // Verify pubkey is registered
        // const { data, error } = await supabase
        //     .from("ephemeral_keys")
        //     .select("*")
        //     .eq("pubkey", signedMessage.ephemeralPubkey.toString())
        //     .single();


        // if (!data) {

        //     await supabase
        //         .from("ephemeral_keys")
        //         .insert({
        //             pubkey: signedMessage?.ephemeralPubkey?.toString(),
        //             signature: signedMessage?.signature?.toString(),
        //             uuid: uuid,
        //         })

        //     // throw new Error("Ephemeral key not registered");
        // }

        await supabase
            .from("ephemeral_keys")
            .upsert({
                pubkey: signedMessage?.ephemeralPubkey?.toString(),
                signature: signedMessage?.signature?.toString(),
                uuid: uuid,
            }).eq("pubkey", signedMessage?.ephemeralPubkey?.toString())

        const nationality = verification.queryResult.nationality?.disclose?.result;
        const age = verification.queryResult.age?.disclose?.result;
        const gender = verification.queryResult.gender?.disclose?.result;

        const { error: insertError, data: insertData } = await supabase.from("passport_registrations").update({
            is_verified: true,
            id_register: uuid,
            pubkey: pubkey,
            group_id: uuid,
            provider: signedMessage?.anonGroupProvider ?? "zk-passport",
            proof: proofs,
            proof_args: queryResult,
            nationality: nationality,
            date_of_birth: age,
            gender: gender,
        }).eq("pubkey", pubkey);

        if (insertError) {
            return res.status(400).json({
                success: false,
                error: "Failed to insert passport registration",
            });
        }


        return res.status(200).json({
            success: true,
            message: "User created successfully",
            data: insertData,
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