import { NextApiRequest, NextApiResponse } from 'next';
import * as fs from 'fs';
import path from 'path';
import { prepareInputs } from '@/lib/noir/jwt';

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
    const { jwt } = req.body;

    if (!jwt) {
        return res.status(400).json({ error: 'JWT is required' });
    }

    // Load Noir WASM (ensure you've compiled your circuit)
    const circuitPath = path.resolve('./noir-circuit/target/circuit.wasm');
    const wasmBuffer = fs.readFileSync(circuitPath);

    //   await initThreadPool(wasmBuffer); // Initialize Noir WASM

    //   const compiledCircuit = await compile({ wasm: wasmBuffer });

    //   // Assume RSA pubkey and signature conversion
    //   const noirInputs = await prepareInputs(jwt); // custom logic

    //   const proof = await generateProof(compiledCircuit, noirInputs);

    let proof = "test";
    res.status(200).json({ proof });
}
