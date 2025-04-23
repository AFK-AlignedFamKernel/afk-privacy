import { decodeJwt } from 'jose';
import { exportJWK } from 'jose';
import { createPublicKey } from 'crypto';

// Split a buffer or hex string into limb-sized Field elements
function splitToLimbs(buffer: Buffer, limbSize = 32): string[] {
  const limbs = [];
  for (let i = 0; i < buffer.length; i += limbSize) {
    const chunk = buffer.slice(i, i + limbSize);
    limbs.push(BigInt('0x' + chunk.toString('hex')).toString());
  }
  return limbs;
}

export async function prepareInputs(jwt: string, publicKeyPem: string) {
  const [headerB64, payloadB64, signatureB64] = jwt.split(".");

  // 1. Prepare JWT data
  const data = Buffer.from(`${headerB64}.${payloadB64}`);
  const base64_decode_offset = headerB64.length + 1; // "." after header

  // 2. Convert expected claims (for ZK assertions)
  const decodedJwt = decodeJwt(jwt);
  const expected_email = Buffer.from(decodedJwt.email as string);
  const expected_twitter = Buffer.from(decodedJwt.twitter_id as string);

  // 3. Prepare RSA public key modulus limbs
  const publicKey = createPublicKey(publicKeyPem);
  const jwk = await exportJWK(publicKey);
  const modulusHex = jwk.n ? Buffer.from(jwk.n, 'base64url').toString('hex') : '';
  const pubkey_modulus_limbs = splitToLimbs(Buffer.from(modulusHex, 'hex'));

  // 4. Prepare signature limbs
  const signatureBuffer = Buffer.from(signatureB64, 'base64url');
  const signature_limbs = splitToLimbs(signatureBuffer);

  // 5. Set redc_params_limbs same as modulus (or adjust for real RSA impl)
  const redc_params_limbs = pubkey_modulus_limbs;

  return {
    data,
    base64_decode_offset,
    pubkey_modulus_limbs,
    redc_params_limbs,
    signature_limbs,
    expected_email,
    expected_twitter,
  };
}
